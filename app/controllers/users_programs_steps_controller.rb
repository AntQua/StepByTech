class UsersProgramsStepsController < ApplicationController
  before_action :set_program_and_step, only: [:apply_for_next_step, :apply_to_program, :apply]
  layout "dashboard"

  def apply
    @program = Program.find(params[:program_id])
  end

  def apply_to_program
    user = User.find(current_user.id)

    answers = []
    params[:checked].each do |check|
      answer = user.user_attributes.build({
        :program_attribute_id => check
      })
      answers.push(answer)
    end

    begin
      success = []
      UserAttribute.transaction do
        success = answers.map(&:save)
        raise ActiveRecord::Rollback unless success.all?
      end
      if success.all?
        initial_step = @program.steps.where(step_order: 0).first
        if initial_step != nil
          user_program_step = current_user.users_programs_steps.build({
                                                                        program_id: @program.id,
                                                                        step_id: initial_step.id,
                                                                        registration_date: DateTime.now,
                                                                        status: 0
                                                                      })
          current_user.save!
        end
        redirect_to apply_path(@program), notice: 'Candidatura realizada com sucesso!'
      else
        redirect_to apply_path(@program), alert: 'Não foi possivel realizar sua candidatura!'
      end
    rescue
      redirect_to apply_path(@program), alert: 'Não foi possível realizar sua candidatura!'
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
