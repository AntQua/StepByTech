class ProgramsController < ApplicationController
  before_action :authenticate_user!, except: [:detail]
  before_action :set_program, only: [:show, :detail, :edit, :update, :destroy]
  before_action :authorize_program, except: [:index, :show]
  # layout "dashboard", only: [:index, :new, :show]

  # GET /programs
  def index
    @programs = Program.all

    render 'programs_list', layout: 'dashboard'
  end

  # GET /programs/1
  def show
    authorize Program
    @program_events = @program.events.where(status: "agendado")

    # Fetch posts related to the program and its steps, ordered by most recent
    @program_posts = Post.where(program_id: @program.id).order(created_at: :desc)
    @step_posts = Post.where(step_id: @program.steps.ids).order(created_at: :desc)

    render layout: 'dashboard'
  end

  def detail
  end

  # GET /programs/new
  def new
    authorize Program
    @program = Program.new
    render 'new_program_form', layout: 'dashboard'
  end

  # POST /programs
  def create
    @program = Program.new(program_params)
    if params[:program][:image].present?
      @program.image.attach(params[:program][:image])
    end
    @program.save
    initial_step = @program.steps.build({
                                          name: "Candidatura",
                                          step_order: 0,
                                          active: false,
                                          format: "Online",
                                          dates: [@program.registration_start_date, @program.registration_end_date],
                                          hour_start: nil,
                                          hour_finish: nil
                                        })

    if @program.save
      redirect_to programs_path, notice: 'O programa foi criado com sucesso.'
    else
      render :new
    end
  end

  # GET /programs/1/edit
  def edit
    render 'edit_program_form', layout: 'dashboard'
  end

  # PATCH/PUT /programs/1
  def update
    if @program.update(program_params)
      if params[:program][:image].present?
        @program.image.attach(params[:program][:image])
      end
      @program.save
      redirect_to program_path(@program), notice: 'Program was successfully updated.'
    else
      render 'edit_program_form', layout: 'dashboard'
    end
  end

  # DELETE /programs/1
  def destroy
    @program.steps.destroy_all
    @program.destroy
    redirect_to programs_path, notice: 'Program was successfully deleted.'
  end

  def steps
    program = Program.find(params[:id])
    steps = program.steps.map do |step|
      { id: step.id, name_with_order: step.name_with_order }
    end
    render json: steps
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_program
    @program = Program.find(params[:program_id] || params[:id])
  end

  # Only allow a list of trusted parameters through.
  def program_params
    params.require(:program).permit(:title, :description, :preview, :registration_start_date, :registration_end_date, :begin_date, :end_date, :registration_limit, :active, :completed)
  end

  def authorize_program
    authorize @program || Program
  end

  # def pundit_policy_scoped?
  #   true # ou substitua por lógica que indica quando o scoping deve ser realizado
  # end
end
