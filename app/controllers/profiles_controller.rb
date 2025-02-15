class ProfilesController < ApplicationController
  def index
    search_query = params[:query].presence
    @q = User.ransack(username_cont: search_query) # Initialize Ransack query object
    @users = @q.result(distinct: true) # Execute the query and ensure distinct results
    Rails.logger.info "Found users: #{@users.map(&:id)}" # Debugging
  end

  def users
    #Searching for user not working
    search_query = params[:query] # Or however you’re getting the search input
    query = User.ransack(username_cont: search_query)
    @users = query.result(distinct: true)

  end
  
  #not working
  def Songs 
    search_query = params[:query] # Or however you’re getting the search input
  
    query2 = Song.ransack(username_cont: search_query)

    @songs = query2.result(distinct: true)
  end 

  #def search_query
   # params[:query]
 # end 
end
