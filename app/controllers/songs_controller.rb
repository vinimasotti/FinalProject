class SongsController < ApplicationController


  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_song, only: [:show, :edit, :destroy]


    def new #New instance for the Song model
      @song = Song.new
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
      @song = Song.new(song_params)
      if @song.save
        redirect_to @song, notice: "Song was successfully uploaded."
      else
        render :new, alert: "Error uploading the song."
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
  
    private

    def set_song
      @song = Song.find(params[:id])
    end
  
    def song_params
      params.require(:song).permit(:title, :artist, :audio_file)
    end
  end