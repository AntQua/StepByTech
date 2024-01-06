class UsersProgramsStepsController < ApplicationController
  before_action :set_program_and_step, only: [:apply_for_next_step, :apply_to_program, :apply, :update_step_candidate, :table_data, :approve, :disapprove, :questionnaire, :answer_questionnaire, :cancel_apply_to_program, :view_candidate]
  layout "dashboard"

  def apply
    current_date = Date.today
    candidate_step = @program.steps.where({ name: "Candidatura", step_order: 0 }).first
    if candidate_step != nil &&
      current_date >= @program.registration_start_date &&
      current_date <= @program.registration_end_date &&
      current_user.users_programs_steps.exists?(program_id: @program.id) == false

      @questions = @program.step_questions.where(step_id: candidate_step.id).sort_by { |question| question.id }
    else
      redirect_to program_path(@program), alert: "Não é possivel se candidatar!"
    end
  end

  def apply_to_program
    current_date = Date.today
    candidate_step = @program.steps.find_by(name: "Candidatura", step_order: 0)
    if candidate_step &&
      current_date.between?(@program.registration_start_date, @program.registration_end_date) &&
      !current_user.users_programs_steps.exists?(program_id: @program.id)

      if valid_answers_limit?
        answers = build_answers
        if save_answers(answers)
          data_protection_usage = params['checkboxTratamento'] == 'on'
          data_protection_divulgation = params['checkboxDivulgacao'] == 'on'
          data_protection_evaluation = params['checkboxAvaliacao'] == 'on'
          data_protection_terms = params['checkboxPoliticaPrivacidade'] == 'on'
          
          create_user_program_step(data_protection_usage, data_protection_divulgation, data_protection_evaluation, data_protection_terms)
          EventMailer.apply_program_email(current_user, @program).deliver_now

          redirect_to program_path(@program), notice: 'Candidatura realizada com sucesso!'
        else
          redirect_to_program_with_alert
        end
      else
        redirect_to apply_path(@program), notice: 'Não foi possivel realizar a candidatura, limite de resposta de alguma questão foi excedida!'
      end
    else
      redirect_to_program_with_alert
    end
  end

  def cancel_apply_to_program
    user_program_step_to_delete = current_user.users_programs_steps.find_by(program_id: @program.id)

    if user_program_step_to_delete&.present?
      step = user_program_step_to_delete.step
      if user_program_step_to_delete.destroy && step.step_questions.present?
        questions_options = step.step_questions.flat_map { |question| question.step_question_options }
        answers_to_delete = current_user.user_answers.select { |answer| questions_options.any? { |option| answer.step_question_option_id == option.id } }
        if answers_to_delete.map(&:destroy)
          redirect_to dashboard_path, notice: 'Inscrição ao programa cancelada com sucesso!'
        end
      else
        redirect_to dashboard_path, notice: 'Inscrição ao programa cancelada com sucesso!'
      end
    end
  end

  def valid_answers_limit?
    options = params[:checked]

    return true unless options.present?

    questions = options.map { |option_id| StepQuestionOption.find(option_id)&.step_question }.uniq

    questions.none? do |question|
      count = options.count { |option_id| question.step_question_options.any? { |qo| qo.id == option_id.to_i } }
      count > question.limit
    end
  end

  def build_answers
    answers = []
    params[:checked].each { |option_id| answers << current_user.user_answers.build(step_question_option_id: option_id) } if params[:checked].present?
    params[:textAnswers].each do |option_text|
      step_question_option_id, text = option_text
      answers << current_user.user_answers.build(step_question_option_id: step_question_option_id, text: text)
    end if params[:textAnswers].present?
    answers
  end

  def save_answers(answers)
    UserAnswer.transaction do
      answers.all?(&:save)
    end
  end

  def view_candidate
    if @user_program_step
      @questions_and_answers = {}

      @user_program_step.user.user_answers.includes(:step_question_option).each do |user_answer|
        step = user_answer.step_question_option.step_question.step
        user_id = user_answer.user_id
        question_id = user_answer.step_question_option.step_question_id
        question_title = user_answer.step_question_option.step_question.title
        question_type = user_answer.step_question_option.step_question.question_type_before_type_cast
        answer_text = user_answer.text || user_answer.step_question_option.title
        answer_custom_weight = user_answer.custom_weight != nil
        answer_weight = answer_custom_weight ? user_answer.custom_weight : user_answer.step_question_option.weight

        if step
          user_program_step = step.users_programs_steps.find_by(:user_id => user_id)

          # Verificar se já existe um grupo para este step
          @questions_and_answers[step.name] ||= { id: step.id, user_program_step_id: (user_program_step != nil ? user_program_step.id : 0), total_points: 0, questions: {} }

          # Verificar se já existe um grupo para esta pergunta dentro do step
          @questions_and_answers[step.name][:questions][question_id] ||= { id: question_id, title: question_title, type: question_type, answers: [], points: 0 }

          # Verificar se a resposta já existe no array antes de adicioná-la
          unless @questions_and_answers[step.name][:questions][question_id][:answers].any? { |hash| hash[:value] == answer_text }
            @questions_and_answers[step.name][:total_points] += answer_weight
            @questions_and_answers[step.name][:questions][question_id][:points] += answer_weight
            @questions_and_answers[step.name][:questions][question_id][:answers] << { id: user_answer.id, custom_weight: answer_custom_weight, weight: answer_weight, value: answer_text }
          end
        end
      end
    else
      redirect_to program_path(@program), alert: 'Candidato não encontrado!'
    end
  end

  def create_user_program_step(agree_usage, agree_divulgation, agree_evaluation, agree_terms)
    initial_step = @program.steps.find_by(step_order: 0)
    current_user.users_programs_steps.create!(
      program_id: @program.id,
      step_id: initial_step.id,
      registration_date: DateTime.now,
      status: 0, # Aguardando Aprovação
      data_protection_usage: agree_usage,
      data_protection_divulgation: agree_divulgation,
      data_protection_evaluation: agree_evaluation,
      data_protection_terms: agree_terms
    )
  end

  def redirect_to_program_with_alert
    redirect_to program_path(@program), alert: 'Não foi possivel realizar sua candidatura!'
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
        status_description: user_program_step.status,
        status_value: user_program_step.status_before_type_cast,
        evaluated_value: user_program_step.evaluated,
        evaluated: user_program_step.evaluated ? "Sim" : "Não",
        user_id: user_program_step.user.id,
        user_name: user_program_step.user.name,
        user_gender: user_program_step.user.gender,
        user_email: user_program_step.user.email,
        step_id: user_program_step.step.id,
        current_step_name: user_program_step.step.name,
        next_step_name: @program.next_step_name(user_program_step.step.step_order),
        registration_date: user_program_step.registration_date.strftime('%d/%m/%Y'),
        total_points: user_program_step.step.calculate_total_questionnaire(user_program_step.user_id)
      }
    end

    respond_to do |format|
      format.js
      format.json { render json: { data: candidates } }
    end
  end

  def approve
    current_step_order = @user_program_step.step.step_order
    next_step = @user_program_step.program.next_step(current_step_order)
    if next_step != nil
      @user_program_step.status = UsersProgramsStep.statuses.key(1) # Aprovado
      @user_program_step.step = next_step
    else
      @user_program_step.status = UsersProgramsStep.statuses.key(3) # Finalizado
    end

    if @user_program_step.save
      render json: { status: 'success', message: "Candidato aprovado com sucesso!" }, status: :ok
      if current_step_order == 0
        EventMailer.approved_program_email(@user_program_step.user, @user_program_step.program).deliver_now
      elsif next_step != nil
        EventMailer.approved_step_email(@user_program_step.user, next_step).deliver_now
      end
    else
      approve_render_error
    end
  end

  def approve_render_error
    render json: { status: 'error', message: "Falha na tentativa de aprovar o candidato", errors: @user_program_step.errors }, status: :unprocessable_entity
  end

  def disapprove
    @user_program_step.status = UsersProgramsStep.statuses.key(2) # Reprovado
    if @user_program_step.save
      current_step_order = @user_program_step.step.step_order
      next_step = @user_program_step.program.next_step(current_step_order)

      if current_step_order == 0
        EventMailer.disapproved_program_email(@user_program_step.user, @user_program_step.program).deliver_now
      elsif next_step != nil
        EventMailer.disapproved_step_email(@user_program_step.user, next_step).deliver_now
      end
      render json: { status: 'success', message: "Candidato reprovado com sucesso!" }, status: :ok
    else
      render json: { status: 'error', message: "Falha na tentativa de reprovar o candidato", errors: @user_program_step.errors }, status: :unprocessable_entity
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

  def questionnaire
    @current_step = current_user.current_step(@program)
    if @current_step
      @questions = @program.step_questions.where(step: @current_step).order(:id)
    else
      redirect_to program_path(@program), alert: "Não foi possivel visualizar o questionário!"
    end
  end

  def answer_questionnaire
    current_user_program_step = current_user.user_program_step(@program)

    if current_user_program_step&.can_answer_questionnaire?
      answers = build_answers

      if save_answers(answers)
        current_user_program_step.update({ status: UsersProgramsStep.statuses.key(0), evaluated: false })
        EventMailer.submit_step_email(current_user, current_user_program_step.step).deliver_now
        redirect_to program_path(@program), notice: 'Questionário respondido com sucesso!'
      else
        redirect_to program_path(@program), alert: 'Não foi possível responder o questionário!'
      end
    else
      redirect_to program_path(@program), alert: 'Não foi possível responder o questionário!'
    end
  end

  def set_custom_weight
    answer_id = params[:answer_id]&.to_i
    answer = UserAnswer.find_by(id: answer_id)
    if answer
      restore_weight_default = params[:restore_weight_default]
      if restore_weight_default
        answer.custom_weight = nil
      else
        answer_custom_weight = params[:custom_weight]
        answer.custom_weight = answer_custom_weight
      end

      if answer.save
        step = answer.step_question_option.step_question.step
        total = step.calculate_total_questionnaire(answer.user_id)
        has_custom_weight = answer.custom_weight != nil
        weight = has_custom_weight ? answer.custom_weight : answer.step_question_option.weight
        render json: { status: 'success', data: { total: total, weight: weight, has_custom_weight: has_custom_weight }, message: restore_weight_default ? "Nota padrão restaurada com sucesso." : "Nota atribuida com sucesso." }, status: :ok
      else
        render json: { status: 'error', message: "Falha na tentativa de atribuir a nota à resposta do candidato.", errors: answer.errors }, status: :unprocessable_entity
      end
    else
      render json: { status: 'error', message: "Resposta não encontrada" }, status: :unprocessable_entity
    end
  end

  def update_evaluation_status
    user_program_step_id = params[:id].to_i
    user_program_step = UsersProgramsStep.find(user_program_step_id)
    if user_program_step
      user_program_step.evaluated = true
      if user_program_step.save
        render json: { status: 'success', message: "Candidato avaliado com sucesso." }, status: :ok
      else
        render json: { status: 'error', message: "Falha na tentativa de avaliar o candidato.", errors: user_program_step.errors }, status: :unprocessable_entity
      end
    else
      render json: { status: 'error', message: "Falha na tentativa de avaliar o candidato." }, status: :not_found
    end
  end

  private

  def set_program_and_step
    @program = Program.find(params[:program_id]) if params[:program_id]
    @user_program_step = UsersProgramsStep.find(params[:id]) if params[:id]
  end

  def authorize_program
    authorize @program || Program
  end
end
