class EventsController < ApplicationController
  include Pundit

  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :ensure_admin, only: [:new, :create, :edit, :update, :destroy]
  layout "dashboard"

  def index
    @events = Event.all
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
      render :new
    end
  end




  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :status, :type, :program_id, :step_id, :hour_start, :hour_finish)
  end


  def ensure_admin
     redirect_to dashboard_path, alert: "Access denied!" unless current_user.is_admin?
  end
end
