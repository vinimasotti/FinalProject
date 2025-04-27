class SongsController < ApplicationController


  before_action :authenticate_user!
  before_action :set_song, only: [:show, :download, :destroy]
  

  def my_songs
    # Fetch songs uploaded by the current user via their posts
    @songs = Song.joins(:post).where(posts: { user_id: current_user.id }).includes(:post)
  end

    def new #New instance for the Song model
      @song = current_user.songs.new
    end

    def index #Retrieve all songs and display them in a list
      if params[:query].present? && params[:query].strip != "" # Check if the query parameter is present and not empty on server side
        query = ActiveRecord::Base.sanitize_sql_like(params[:query]) #Security measure to prevent SQL injection
        @song = Song.where('artist LIKE :query OR title LIKE :query', query: "%#{query}%").limit(10) # Secure measure to prevent SQL injection
      else
        @song = Song.all 
    end
    end

    def edit
    end

    def show #Display details about the song

      @song = Song.find(params[:id])
    
     # @comment = @post.comments.build
     # @song = @post.song || Song.new  # Assign a new Song if no association exists
  
      @alternate_post = Song.find(params[:id])
    end

    def destroy # Delete song from a database
      begin
        @song.destroy!
        redirect_to songs_path, notice: "Song was successfully deleted."
      rescue ActiveRecord::RecordNotDestroyed => e
        redirect_to @song, alert: "Error deleting the song: #{e.message}"
      end
    end
  
    def create # Handle submission for creating a new song
      @song = current_user.songs.new(song_params)  # assign user here

      if @song.save
        redirect_to @song, notice: "Song uploaded successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def search
      if params[:query].present?
        query = ActiveRecord::Base.sanitize_sql_like(params[:query]) #Security measure to prevent SQL injection
        @song = Song.where('artist LIKE :query OR title LIKE :query', query: "%#{query}%").limit(10) # Secure measure to prevent SQL injection
      else
        @song = Song.all #limiting 10 songs to not overload the page.
    end
    end

    def download
      # Generate a secure, expiring URL for the audio file
      if @song.audio_file.attached?
        redirect_to @song.audio_file.service_url(disposition: 'attachment', expires_in: 5.minutes, content_type: @song.audio_file.content_type)
      else
        redirect_to songs_path, alert: "Audio file not found."
      end
    end
  
    private

    def set_song
      @song = current_user.songs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to songs_path, alert: "Song not found or access denied."
  end
    
  
    def song_params
      params.require(:song).permit(:title, :artist, :audio_file)
    end
  end