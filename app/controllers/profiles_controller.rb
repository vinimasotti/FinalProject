class ProfilesController < ApplicationController
  def index
    @users = users
  end

  def users
    #Searching for user not working
    search_query = params[:query] # Or however you’re getting the search input
    query = User.ransack(username_cont: search_query)
    @users = query.result(distinct: true)
  end

  def search_query
    params[:query]
  end 
end
