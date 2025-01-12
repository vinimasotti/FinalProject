class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!

  def users
    # Retrieve the search query from params
    search_query = params[:query].presence
  
    # Log the search query for debugging
    Rails.logger.info "Search query: #{search_query}"
  
    # Perform the search using Ransack
    query = User.ransack(username_cont: search_query)
  
    # Ensure distinct results
    @users = query.result(distinct: true)
  
    # Debugging: Log found users
    Rails.logger.info "Found users: #{@users.pluck(:id)}"
  end

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
  end

  def show
    @user = User.find(params[:id])
  end

  def follow
    current_user.send_follow_request_to(@user)
    @user.accept_follow_request_of(current_user)
    redirect_to users_path(@user)
  end

  def unfollow
    current_user.unfollow(@user)
    redirect_to users_path(@user)
  end

  def accept
    current_user.accept_follow_request_or(@user)
    redirect_to users_path(@user)
  end

  def decline
    current_user.decline_follow_request_of(@user)
    redirect_to users_path(@user)
  end

  def cancel
    current_user.remove_follow_request_for(@user)
    redirect_to users_path(@user)
  end 

  def set_user
    @user = User.find(params[:id])
  end


end
