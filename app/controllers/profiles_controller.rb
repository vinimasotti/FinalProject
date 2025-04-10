class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :posts, :follow, :unfollow, :accept, :decline, :cancel]
  def index
    search_query = params[:query].presence
    @q = User.ransack(username_cont: search_query) # Initialize Ransack query object
    @users = @q.result(distinct: true) # Execute the query and ensure distinct results
    Rails.logger.info "Found users: #{@users.map(&:id)}" # Debugging
  end

#Incomplete
  def posts
    user = User.find(params[:id]) # Find the user by ID
    @posts = user.posts # Fetch posts associated with the user
  
  end

  def users
    #Searching for user not working
    #search_query = params[:query] # Or however you’re getting the search input
   # query = User.ransack(username_cont: search_query)
   # @users = query.result(distinct: true)

  end
  

  def Songs 
   # search_query = params[:query] # Or however you’re getting the search input
   # query2 = Song.ransack(username_cont: search_query)
   # @songs = query2.result(distinct: true)
  end 

  #def search_query
   # params[:query]
 # end 
end
