class StepsController < ApplicationController
  before_action :set_program
  layout "dashboard"

  before_action :authorize_step

  def new
    @step = @program.steps.build
    render layout: 'dashboard'
  end

  def create
    Rails.logger.info params.inspect

    params[:step][:dates] = params[:step][:dates].split(",").map { |date_str| Date.parse(date_str) }
    params[:step][:dates].reject!(&:blank?)

    @step = @program.steps.build(step_params)
    # if @step.save
    #   redirect_to program_path(@program), notice: 'Step was successfully created.'
    # else
    #   render :new, layout: 'dashboard'
    # end
    if @step.save
      redirect_to program_path(@program), notice: 'Step was successfully created.'
    else
          # Log the errors
      Rails.logger.info "Step failed to save due to the following errors:"
      Rails.logger.info @step.errors.full_messages.to_s
      redirect_to new_program_step_path(@program), alert: 'There were errors creating the step.'
    end
  end

  def show
    @step = Step.find(params[:id])
    Rails.logger.info "Step Dates: #{@step.dates}"
  end

  def edit
    @program = Program.find(params[:program_id])
    @step = @program.steps.find(params[:id])

    Rails.logger.info "Existing dates in edit action: #{@step.dates}"
  end

  def update
    @program = Program.find(params[:program_id])
    @step = @program.steps.find(params[:id])

    # Log the existing dates before update
    Rails.logger.info "Existing dates before update: #{@step.dates}"

    params[:step][:dates] = params[:step][:dates].split(",").map { |date_str| Date.parse(date_str) }
    params[:step][:dates].reject!(&:blank?)

    updated_params = step_params.merge(dates: params[:step][:dates])

    Rails.logger.info updated_params.inspect
    if @step.update(updated_params)
      redirect_to program_step_path(@program, @step), notice: 'Step was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @step = @program.steps.find(params[:id])
    @step.destroy
    redirect_to program_path(@program), notice: "Step was successfully deleted."
  end


  private

  def set_program
    @program = Program.find(params[:program_id])
  end

  def step_params
    params.require(:step).permit(:name, :step_order, :submission, :active, :description, :format, :hour_start, :hour_finish, {dates: []})
  end

  def authorize_step
    authorize @step || Step
  end

end
