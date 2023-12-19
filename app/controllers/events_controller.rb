class EventsController < ApplicationController
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :participate, :unregister]
  before_action :ensure_admin, only: [:new, :create, :edit, :update, :destroy]
  layout "dashboard"

  def index
    @agendados_events = Event.where(status: "agendado")
    @terminados_events = Event.where(status: "terminado")
    # Fetch posts associated with events
    @event_posts = Post.includes(:event).where.not(event_id: nil).order(created_at: :desc)
  end


  def show
    authorize @event
    @programs = Program.where(active: true)
    # Eager load users with their programs
    @event = Event.includes(users: :programs).find(params[:id])
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
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @event
    @programs = Program.where(active: true)
    @steps = @event.program&.steps || [] # This will fetch steps if a program is associated
  end


  def update
    authorize @event
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      @programs = Program.where(active: true)
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
    unless @event.users.include?(current_user)
      @event.users << current_user
      # Send email notification
      EventMailer.participation_email(current_user, @event).deliver_now
      message = "Você ingressou no evento com sucesso! Verifique o seu email."
    else
      message = "Você já está inscrito neste evento!"
    end

    redirect_to @event, notice: message
  end


  def unregister
    if @event.users.include?(current_user)
      # Disassociate the current user from the event
      @event.users.delete(current_user)

      # Send email notification
      EventMailer.unregistration_email(current_user, @event).deliver_now

      message = "Você cancelou a inscrição no evento com sucesso! Verifique o seu email."
    else
      message = "Você não está inscrito neste evento!"
    end

    redirect_to @event, notice: message
  end


  def export_excel
    @event = Event.find(params[:id])
    request.format = :xlsx
    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="event_users.xlsx"'
        render layout: false
      end
    end
  end

  def export_pdf
    @event = Event.find(params[:id])

    respond_to do |format|
      format.pdf do
        render pdf: "event_users",
               template: "events/export_pdf",
               formats: [:html],
               layout: "pdf",
               orientation: "Landscape",
               page_size: "A4",
               disposition: "attachment"
      end
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :status, :event_type, :program_id, :step_id, :hour_start, :hour_finish, :event_link, :event_location, :image).tap do |whitelisted|
      whitelisted[:program_id] = nil if whitelisted[:program_id].blank?
      whitelisted[:step_id] = nil if whitelisted[:step_id].blank?
    end
  end

  def ensure_admin
     redirect_to dashboard_path, alert: "Access denied!" unless current_user.is_admin?
  end
end
