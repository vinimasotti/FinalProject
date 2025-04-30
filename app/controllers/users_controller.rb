class UsersController < ApplicationController
  before_action :set_user, only: [:show, :follow, :unfollow]
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
  @total_uploaded_data_size = @user.total_uploaded_data_size
      @total_uploaded_song_data_size = @user.total_uploaded_song_data_size
      @total_combined_data_size = @total_uploaded_data_size + @total_uploaded_song_data_size
      @exceeds_data_limit = @total_combined_data_size > 1.gigabyte
      @is_following = current_user.following?(@user)
      @sent_follow_request = current_user.sent_follow_request_to?(@user)
      @is_current_user = current_user == @user
  end

  def follow
    current_user.send_follow_request_to(@user)
  @user.accept_follow_request_of(current_user)
  redirect_to user_path(@user), notice: "You are now following #{@user.username}."
  end

  def unfollow
    current_user.unfollow(@user) if current_user.following?(@user)
    redirect_to user_path(@user), notice: "You have unfollowed #{@user.username}."
  end

   def posts
    @user = User.find(params[:user_id])
    @posts = @user.posts.order(created_at: :desc)
    

  end

  private 
  # Sets the @user instance variable by finding a User record based on the provided :id parameter.
  # This method is typically used as a before_action filter to load the user for actions that require it.
  # It is recommended to keep this method private, as it is an internal helper method and should not be
  # directly accessible as a controller action.
  
  def set_user
    @user = User.find(params[:id] || params[:user_id])
  end

 


end
