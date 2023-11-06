class RenameStepQuestionAnswerToStepQuestionOption < ActiveRecord::Migration[7.0]
  def change
    rename_table :step_question_answers, :step_question_options
  end
end
