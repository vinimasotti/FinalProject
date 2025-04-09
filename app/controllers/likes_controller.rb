class LikesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @like = current_user.likes.new(like_params)
    if @like.save
      redirect_to @like.post, notice: "Liked successfully!"
      #flash[:alert] = "You already liked this post"
      else
      redirect_to @like.post, alert: "Unable to like the post."
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @like.destroy
  end

  private 
  def like_params
    params.require(:like).permit(:post_id)
  end
end
