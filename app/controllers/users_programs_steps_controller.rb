class UsersProgramsStepsController < ApplicationController
  before_action :set_program_and_step, only: [:apply_for_next_step, :apply_to_program, :apply]
  layout "dashboard"

  def apply
    @program = Program.find(params[:program_id])
  end

  def apply_to_program
    ups = UsersProgramsStep.new(user: current_user, program: @program, step: @program.steps.first)
    if ups.save
      redirect_to program_path(@program), notice: 'Successfully applied to the program!'
    else
      redirect_to program_path(@program), alert: 'Failed to apply!'
    end
  end

  def apply_for_next_step
    ups = UsersProgramsStep.find_by(user: current_user, program: @program)
    if ups&.accepted?
      next_step = @program.steps.where("step_order > ?", ups.step.step_order).first
      if next_step
        ups.update(step: next_step, status: "applied")
        redirect_to step_path(next_step), notice: 'Applied for the next step!'
      else
        redirect_to program_path(@program), alert: 'No next step available!'
      end
    else
      redirect_to step_path(ups.step), alert: 'You are not approved for the next step!'
    end
  end

  private

  def set_program_and_step
    @program = Program.find(params[:program_id])
    @step = Step.find(params[:id]) if params[:id]
  end
end
