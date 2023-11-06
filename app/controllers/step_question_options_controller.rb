class StepQuestionOptionsController < ApplicationController
  before_action :set_step_question_option, only: [:save]

  def table_data
    @program = Program.find(params[:program_id])
    @questions_options = @program.step_question_options.sort_by { |sqo| sqo.step_question.step.step_order }.map do |sqo| {
      id: sqo.id,
      title: sqo.title,
      step_question_title: sqo.step_question.title,
      step_question_id: sqo.step_question_id,
      weight: sqo.weight
    }
    end

    respond_to do |format|
      format.js
      format.json { render json: { data: @questions_options } }
    end
  end

  def save
    if params[:id].present?
      @step_question_option.update!(step_question_option_params)
    else
      @step_question_option.save
    end

    @options = StepQuestionOption.all.sort_by(&:id)

    render json: { data: @options }, status: :ok
  end

  private

  def step_question_option_params
    params.require(:step_question_option).permit(:step_question_id, :title, :weight)
  end

  def set_step_question_option
    @step_question_option = params[:id].present? ? StepQuestionOption.find(params[:id]) : nil
    @step_question = params[:step_question_id].present? ? StepQuestion.find(params[:step_question_id]) : nil
    @program = params[:program_id].present? ? Program.find(params[:program_id]) : nil

    if @step_question && !@step_question_option
      @step_question_option = @step_question.step_question_options.build(step_question_option_params)
    end
  end
end
