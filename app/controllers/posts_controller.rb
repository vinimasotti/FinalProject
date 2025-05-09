class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
    @song = Song.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.build
    @song = @post.song || Song.new  # Assign a new Song if no association exists
    @alternate_post = Post.find(params[:id])
  end

  def myposts
    @posts = current_user.posts.includes(:user) 
  end

  # GET /posts/new
  def new
    @post = Post.new
    @song = Song.new

  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    #@song = Song.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
   end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    @query = params[:query]
    @posts = if @query.present?
          Post.where("title LIKE ? OR artist LIKE ?", "%#{@query}%", "%#{@query}%")
        else
          Post.all
        end
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(
        :title,
        :description,
        :user_id,
        :song,
        images: []  # permit images as an array
      )
    end
    private

    def images_are_valid
      return unless images.attached?
      
      images.each do |image|
        unless image.content_type.in?(%w[image/jpeg image/png image/gif image/webp])
          errors.add(:images, 'must be a JPEG, PNG, GIF, or WEBP')
        end
        
        if image.byte_size > 5.megabytes
          errors.add(:images, 'should be less than 5MB each')
        end
      end
    end
  end 
