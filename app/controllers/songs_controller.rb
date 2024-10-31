class SongsController < ApplicationController
    def new
      @song = Song.new
    end
  
    def create
      @song = Song.new(song_params)
      if @song.save
        redirect_to @song, notice: "Song was successfully uploaded."
      else
        render :new
      end
    end
  
    private
  
    def song_params
      params.require(:song).permit(:title, :audio_file)
    end
  end