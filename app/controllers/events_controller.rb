class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, only: [:new, :create, :edit, :update, :destroy]
  layout "dashboard"

  def new
    @event = Event.new
    @programs = Program.where(active: true)
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to dashboard_path, notice: "Event created successfully!"
    else
      @programs = Program.where(active: true)
      render :new
    end
  end

  # ... any other actions you might want to add ...

  private

  def event_params
    params.require(:event).permit(:title, :description, :date, :status, :type, :program_id, :step_id)
  end

  def ensure_admin
    redirect_to dashboard_path, alert: "Access denied!" unless current_user.is_admin?
  end
end

