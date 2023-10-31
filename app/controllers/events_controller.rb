class EventsController < ApplicationController
  include Pundit

  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :participate, :unregister]
  before_action :ensure_admin, only: [:new, :create, :edit, :update, :destroy]
  layout "dashboard"

  def index
    @events = Event.all
  end

  def show
    authorize @event
    @programs = Program.where(active: true)
  end

  def new
    @event = Event.new
    authorize @event # Add this line
    @programs = Program.where(active: true)
  end


  def create
    @event = Event.new(event_params)
    authorize @event
    if @event.save
      redirect_to events_path, notice: "Event created successfully!"
    else
      @programs = Program.where(active: true)
      puts @event.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @event
    @programs = Program.where(active: true)
  end

  def update
    authorize @event
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      @programs = Program.where(active: true)
      puts @event.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event
    @event.destroy
    redirect_to events_path, notice: "Event deleted successfully!"
  end


  #Adding Users to an Event: When a user decides to participate in an event
  def participate
    # Check if the user is already registered
    unless @event.users.include?(current_user)
      # Associate the current user with the event
      @event.users << current_user
      message = "You have successfully joined the event!"
    else
      message = "You are already registered for this event!"
    end

    redirect_to @event, notice: message
  end

  def unregister
    if @event.users.include?(current_user)
      # Disassociate the current user from the event
      @event.users.delete(current_user)
      message = "You have successfully unregistered from the event!"
    else
      message = "You are not registered for this event!"
    end

    redirect_to @event, notice: message
  end




  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :status, :event_type, :program_id, :step_id, :hour_start, :hour_finish, :event_link, :event_location).tap do |whitelisted|
      whitelisted[:program_id] = nil if whitelisted[:program_id].blank?
      whitelisted[:step_id] = nil if whitelisted[:step_id].blank?
    end
  end

  def ensure_admin
     redirect_to dashboard_path, alert: "Access denied!" unless current_user.is_admin?
  end
end
