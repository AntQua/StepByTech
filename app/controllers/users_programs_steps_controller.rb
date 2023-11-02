class UsersProgramsStepsController < ApplicationController
  before_action :set_program_and_step, only: [:apply_for_next_step, :apply_to_program, :apply, :update_step_candidate, :table_data]
  before_action :authorize_program
  layout "dashboard"

  def apply
  end

  def apply_to_program
    user = User.find(current_user.id)

    answers = []
    params[:checked].each do |check|
      answer = user.user_attributes.build({ :program_attribute_id => check })
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
                                                                        status: 0 # Registrado
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

  def table_data
    candidates = @program.users_programs_steps.sort_by(&:id).map do |user_program_step|
      {
        id: user_program_step.id,
        status: user_program_step.status,
        user_id: user_program_step.user.id,
        user_name: user_program_step.user.name,
        user_gender: user_program_step.user.gender,
        user_email: user_program_step.user.email,
        step_id: user_program_step.step.id,
        step_name: user_program_step.step.name,
        registration_date: user_program_step.registration_date.strftime('%d/%m/%Y'),
        total_points: user_program_step.user.user_attributes.sum { |user_attribute| user_attribute.program_attribute.weight }
      }
    end

    respond_to do |format|
      format.js
      format.json { render json: { data: candidates } }
    end
  end

  def update_step_candidate
    user_program_step = @program.users_programs_steps.find(params[:id])
    if user_program_step != nil
      user_program_step.step_id = params[:step_id]
      user_program_step.save
    end

    render json: { data: user_program_step }, status: :ok
  end

  private

  def set_program_and_step
    @program = Program.find(params[:program_id])
    @user_program_step = UsersProgramsStep.find(params[:id]) if params[:id]
  end

  def authorize_program
    authorize @program || Program
  end
end
