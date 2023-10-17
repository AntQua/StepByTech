class StepsController < ApplicationController
  before_action :set_program
  layout "dashboard"

  def new
    @step = @program.steps.build
    render layout: 'dashboard'
  end

  def create
    @step = @program.steps.build(step_params)
    if @step.save
      redirect_to program_path(@program), notice: 'Step was successfully created.'
    else
      render :new, layout: 'dashboard'
    end
  end

  def show
    @step = Step.find(params[:id])
  end

  def edit
    @program = Program.find(params[:program_id])
    @step = @program.steps.find(params[:id])
  end

  def update
    @program = Program.find(params[:program_id])
    @step = @program.steps.find(params[:id])
    if @step.update(step_params)
      redirect_to program_step_path(@program, @step), notice: 'Step was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_program
    @program = Program.find(params[:program_id])
  end

  def step_params
    params.require(:step).permit(:name, :step_order, :submission, :active, :description, :format, :hour_start, :hour_finish, {dates: []})
  end
end
