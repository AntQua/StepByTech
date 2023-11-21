class RenameStepQuestionsIdToStepQuestionIdInStepQuestionOptions < ActiveRecord::Migration[7.0]
  def change
    rename_column :step_question_options, :step_questions_id, :step_question_id
  end
end
