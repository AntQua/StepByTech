class ProgramsController < ApplicationController
  before_action :set_program, only: [:show, :edit, :update, :destroy]
  layout "dashboard", only: [:index, :new, :show]

  # GET /programs
  def index
    @programs = Program.all

    # Check if the request is AJAX
    # if request.xhr?
    #   render partial: 'programs_list', locals: { programs: @programs }
    # end

    render 'programs_list', layout: 'dashboard'

  end

  # GET /programs/1
  def show
    render layout: 'dashboard'
  end

  # GET /programs/new
  def new
    @program = Program.new

    # # Check if the request is AJAX
    # if request.xhr?
    #   render partial: 'new_program_form', locals: { program: @program }
    # else
    #   # You can handle non-ajax requests if needed
    #   render :new
    # end
    render 'new_program_form', layout: 'dashboard'
  end




  # POST /programs
  def create
    @program = Program.new(program_params)

    if @program.save
      redirect_to programs_path, notice: 'Program was successfully created.'
    else
      render :new
    end
  end

  # GET /programs/1/edit
  def edit
  end

  # PATCH/PUT /programs/1
  def update
    if @program.update(program_params)
      redirect_to @program, notice: 'Program was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /programs/1
  def destroy
    @program.destroy
    redirect_to programs_url, notice: 'Program was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_program
    @program = Program.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def program_params
    params.require(:program).permit(:title, :description, :registration_start_date, :registration_end_date, :begin_date, :end_date, :registration_limit, :active, :completed)
  end
end
