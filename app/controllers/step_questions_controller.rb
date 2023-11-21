class StepQuestionsController < ApplicationController
  before_action :set_step_question, only: [:save, :edit, :update, :destroy]
  before_action :authorize_step_questions
  layout "dashboard"

  def new
    @question = StepQuestion.new
    @program = Program.find(params[:program_id])
    @steps = Step.where(program_id: params[:program_id])
    if @steps.present?
      @steps = @steps.map { |step| [step[:name], step[:id]] } # [Label, Value]
    end
  end

  def create
    @question = StepQuestion.new(step_question_params)
    if @question.save
      if params[:options].present?
        params[:options].each do |option|
          question_option = @question.step_question_options.build({ title: option[:title], weight: option[:weight].to_i })
          question_option.save
        end
      end
      render json: { status: 'success', message: "Questão cadastrada com sucesso!" }, status: :ok
    else
      render json: { status: 'error', message: "Falha ao cadastrar a questão", errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def edit
    @question = @step_question
    @steps = @program.steps
    @options = @question.step_question_options
    if @steps.present?
      @steps = @steps.map { |step| [step[:name], step[:id]] } # [Label, Value]
    end
  end

  def update
    if @step_question.update(step_question_params)
      update_options
      render json: { status: 'success', message: "Questão alterada com sucesso!" }, status: :ok
    else
      render json: { status: 'error', message: "Falha ao alterar a questão", errors: @step_question.errors }, status: :unprocessable_entity
    end
  end

  def update_options
    old_options = @step_question.step_question_options
    options = params[:options].present? ? params[:options].map { |option| { id: option[:id].to_i, title: option[:title], weight: option[:weight].to_i } } : []
    new_options = options.select { |option| option[:id] == 0 }
    delete_options = old_options.find_all { |old_option| !options.any? { |option| old_option.id == option[:id] } }

    delete_options.each do |option|
      @step_question.step_question_options.delete(option)
    end

    new_options.each do |option|
      @step_question.step_question_options.create({ title: option[:title], weight: option[:weight] })
    end

    @step_question.save
  end

  def destroy
    if @step_question.destroy
      render json: { status: 'success', message: "Questão removida com sucesso!" }, status: :ok
    else
      render json: { status: 'error', message: "Falha ao tentar remover a questão", errors: @step_question.errors }, status: :unprocessable_entity
    end
  end

  def table_data
    @program = Program.find(params[:program_id])
    @questions = @program.step_questions.sort_by { |sq| sq.step.step_order }.map do |sq|
      {
        id: sq.id,
        title: sq.title,
        question_type: sq.question_type,
        step_name: sq.step.name,
        step_id: sq.step_id,
        program_id: @program.id,
        limit: sq.limit
      }
    end

    respond_to do |format|
      format.html { render json: { data: @questions } }
      format.json { render json: { data: @questions } }
    end
  end

  def save
    if params[:id].present?
      @step_question.update!(step_question_params)
    else
      @step_question.save
    end

    @questions = StepQuestion.all.sort_by(&:id)

    render json: { data: @questions }, status: :ok
  end

  def preview
    @step = params[:step_id].present? ? Step.find(params[:step_id]) : nil
  end

  private

  def step_question_params
    params.require(:step_question).permit(:step_id, :title, :question_type, :limit)
  end

  def set_step_question
    @step_question = params[:id].present? ? StepQuestion.find(params[:id]) : nil
    @step = params[:step_id].present? ? Step.find(params[:step_id]) : nil
    @program = params[:program_id].present? ? Program.find(params[:program_id]) : nil

    if @step && !@step_question
      @step_question = @step.step_questions.build(step_question_params)
    end
  end

  def authorize_step_questions
    authorize @step_question || StepQuestion
  end
end
