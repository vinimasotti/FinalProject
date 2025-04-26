class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  
  def create
    @like = @post.likes.new(user: current_user)
    if @like.save
      respond_to do |format|
        format.html { redirect_to @post, notice: "You liked this post." }
        format.js   # for AJAX support
      end
    else
      redirect_to @post, alert: "You cannot like this post more than once."
    end
  end

  def destroy
   # @like = current_user.likes.find(params[:id])
    #@like.destroy
    @like = @post.likes.find_by(user: current_user)
    if @like
      @like.destroy
      respond_to do |format|
        format.html { redirect_to @post, notice: "You unliked this post." }
        format.js
      end
    else
      redirect_to @post, alert: "Like not found."
    end
  end


  private 
 # def like_params
  #  params.require(:like).permit(:post_id)
  def set_post
    @post = Post.find(params[:post_id])
  end
end
