class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize #, except: [:show, :index]

  # GET /posts
  def index
    @posts = Post.where(user_id: current_user.id)
  end

  def all
    @posts = Post.where(user_id: current_user.id)
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :url, :content)
    end

    def authorize
      # checks if there is a current user
      if current_user.nil?
        redirect_to login_url, alert: "Not authorized! Please log in."
      else
        # checks if there is a post and a current user, if not rediect to root
        if @post && @post.user != current_user
          redirect_to root_path, alert: "Not authorized! Only #{@post.user} has access to this post."
        end
      end
    end
end
