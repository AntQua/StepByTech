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
      # Set the association_type before rendering the edit form
    if @post.event_id.present?
      @post.association_type = 'event'
    elsif @post.program_id.present?
      @post.association_type = 'program'
    elsif @post.step_id.present?
      @post.association_type = 'step'
    else
      @post.association_type = 'none'
    end
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)
    #handle_associations(@post, params[:post][:association_type])

    if @post.save
      redirect_to posts_path, notice: "Post created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    #Rails.logger.info params.inspect
    handle_media_contents(@post, params[:remove_media_contents])

    # Reset associations based on the selected association type
    reset_associations(@post, post_params[:association_type])

    # Proceed with the update process
    if @post.update(post_params.except(:remove_media_contents, :media_contents))
      @post.media_contents.attach(post_params[:media_contents]) if post_params[:media_contents].present?
      redirect_to posts_path, notice: 'Post was successfully updated.'
    else
      set_select_collections
      render :edit, status: :unprocessable_entity
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

    def handle_media_contents(post, remove_media_contents)
      if remove_media_contents
        remove_media_contents.each do |id|
          blob = ActiveStorage::Blob.find_signed(id)
          post.media_contents.find_by(blob_id: blob.id).purge_later if blob.present?
        end
      end
    end

    def post_params
      params.require(:post).permit(
        :title,
        :body,
        :user_id,
        :program_id,
        :step_id,
        :event_id,
        :association_type,
        :program_id_for_step,
        media_contents: [],
        remove_media_contents: [],
      )
    end

    def check_admin
      redirect_to(root_url) unless current_user.is_admin?
    end

    def set_select_collections
      @events = Event.all
      @programs = Program.all
      @steps = Step.all
    end

    def reset_associations(post, association_type)
      case association_type
      when 'event'
        post.program_id = nil
        post.step_id = nil
      when 'program'
        post.event_id = nil
        post.step_id = nil
      when 'step'
        post.event_id = nil
        post.program_id = nil
      when 'none'
        post.event_id = nil
        post.program_id = nil
        post.step_id = nil
      end
    end
end
