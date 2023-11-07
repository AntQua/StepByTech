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
    handle_associations(@post, params[:post][:association_type])

    if @post.save
      redirect_to posts_path, notice: "Post created successfully!"
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    # Remove selected media contents if any are marked for deletion
    if params[:remove_media_contents].present?
      params[:remove_media_contents].each do |signed_id|
        blob = ActiveStorage::Blob.find_signed(signed_id)
        @post.media_contents.find_by(blob_id: blob.id).purge_later if blob
      end
    end

    # Handle the addition of new media contents
    handle_media_contents if params[:post][:media_contents].present?

    # Update the post with the other attributes
    if @post.update(post_params.except(:media_contents, :remove_media_contents))
      redirect_to posts_path, notice: 'Post was successfully updated.'
    else
      render :edit
    end

    handle_associations(@post, params[:post][:association_type])

    # Update the post with the other attributes, excluding :association_type
    if @post.update(post_params.except(:association_type))
      redirect_to posts_path, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully destroyed.'
  end

  # Add this action to fetch steps for a selected program for steps via AJAX
  def steps_for_program_for_step
    program = Program.find(params[:program_id])
    steps = program.steps.active # Adjust this to get active steps based on your criteria

    # Respond with a JSON array of steps
    render json: steps
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    # This method processes the media_contents
    def handle_media_contents
      # Check if there are any new files to attach
      if params[:post][:media_contents].present?
        # Append new files without deleting the old ones
        @post.media_contents.attach(params[:post][:media_contents])
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
        :program_id_for_step, # Include the virtual attribute
        media_contents: [],
        remove_media_contents: []
      )
    end

    def check_admin
      redirect_to(root_url) unless current_user.is_admin?
    end

    def set_select_collections
      @events = Event.where(status: 'terminado').includes(:program)
      @programs = Program.all
      @steps = Step.all
    end

    def handle_associations(post, association_type)
      # Resets the associations based on the association type
      post.program_id = post.event_id = post.step_id = nil if association_type == 'none'

      case association_type
      when 'event'
        post.program_id = post.step_id = nil
        post.event_id = post_params[:event_id]
      when 'program'
        post.event_id = post.step_id = nil
        post.program_id = post_params[:program_id]
      when 'step'
        post.event_id = nil
        post.program_id = post_params[:program_id_for_step] # Use program_id_for_step for program association
        post.step_id = post_params[:step_id] # Use step_id for step association
      end
    end
end
