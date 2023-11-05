class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:general]
  before_action :check_admin, only: [:create, :edit, :update, :destroy]
  before_action :set_select_collections, only: [:new, :edit, :create, :update]
  layout "dashboard", except: [:general]


  # GET /posts
  def index
    @posts = Post.includes(:user, :program, :event, :step).all
  end

  def general
    @posts = Post.includes(:user, :program, :event, :step).all
    authorize @posts, :general?
  end

  # GET /posts/1
  def show
    @media_contents = @post.media_contents
  end

  # GET /posts/new
  def new
    @post = Post.new
    @programs = Program.all
    @steps = Step.includes(:program).all
    @events = Event.all
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @programs = Program.all
    @steps = Step.includes(:program).all
    @events = Event.all
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post created successfully!"
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
    redirect_to posts_path, notice: 'Post was successfully destroyed.'
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :user_id, :program_id, :step_id, :event_id, media_contents: []).transform_values{|v| v == "" ? nil : v}
    end

    def check_admin
      redirect_to(root_url) unless current_user.is_admin?
    end

      # Set collections for the form selections
    def set_select_collections
      @events = Event.where(status: 'terminado').includes(:program)
      @programs = Program.all
      @steps = Step.all
    end
end
