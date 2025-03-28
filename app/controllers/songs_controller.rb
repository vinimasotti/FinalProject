class SongsController < ApplicationController


  before_action :authenticate_user!, except: [:index, :show]


    def new #New instance for the Song model
      @song = Song.new
    end

    def index #Retrieve all songs and display them in a list
      if params[:query].present?
        query = ActiveRecord::Base.sanitize_sql_like(params[:query]) #Security measure to prevent SQL injection
        @song = Song.where('artist LIKE ?', "%#{query}%")
      else
        @song = Song.all.limit(20) #limiting 20 songs to not overload the page.
    end
    end

    def edit
    end

    def show #Display details about the song
      @song = Song.find(params[:id])
      
    end

    def destroy # Delete song from a database
      @song = Song.find(params[:id])
      @song.destroy!
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
      @query = params[:query]
      @songs = if @query.present?
                 Song.where("title LIKE ? OR artist LIKE ?", "%#{@query}%", "%#{@query}%")
               else
                 Song.all
               end
      render :index
    end
  
    private

    def set_song
      @song = Song.find(params[:id])
    end
  
    def song_params
      params.require(:song).permit(:title, :artist, :audio_file)
    end
  end