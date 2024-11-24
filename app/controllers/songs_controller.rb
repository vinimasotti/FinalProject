class SongsController < ApplicationController
    def new
      @song = Song.new
    end

    def index
      @song = Song.all

    end

    def show
      @song = Song.find(params[:id])
      
    end

    def destroy
      @song.destroy!
    end
  
    def create
      @song = Song.new(song_params)
      if @song.save
        redirect_to @song, notice: "Song was successfully uploaded."
      else
        render :new
      end
    end
  
    public
  
    def song_params
      params.require(:song).permit(:title, :audio_file)
    end
  end