class StepQuestionsController < ApplicationController
  before_action :set_step_question, only: [:save]
  before_action :authorize_step_questions


  def new
    @question = StepQuestion.new
    @program = Program.find(params[:program_id])
    @steps = Step.where(program_id: params[:program_id])
    if @steps.present?
      @steps = @steps.map { |step| [step[:name], step[:id]]} # [Label, Value]
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
      flash[:notice] = "Questão cadastrada com sucesso!"
      head :ok
    else
      flash[:alert] = "Falha ao salvar a questão"
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def table_data
    @program = Program.find(params[:program_id])
    @questions = @program.step_questions.sort_by { |sq| sq.step.step_order }.map do |sq|{
      id: sq.id,
      title: sq.title,
      question_type: sq.question_type_before_type_cast,
      step_name: sq.step.name,
      step_id: sq.step_id,
      limit: sq.limit,
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
