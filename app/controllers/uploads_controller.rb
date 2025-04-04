class UploadsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @upload = current_user.uploads.new(upload_params)
  
      if @upload.save
        current_user.increment_upload_data(@upload.file.size)
        redirect_to uploads_path, notice: 'File uploaded successfully.'
      else
        render :new
      end
    end
  
    private
  
    def upload_params
      params.require(:upload).permit(:file)
    end
  end