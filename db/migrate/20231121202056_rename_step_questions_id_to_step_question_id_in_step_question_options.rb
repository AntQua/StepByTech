class RenameStepQuestionsIdToStepQuestionIdInStepQuestionOptions < ActiveRecord::Migration[7.0]
  def up
    if column_exists?(:step_question_options, :step_questions_id)
      rename_column :step_question_options, :step_questions_id, :step_question_id
    end
  end

  def down
    # Reverter a migração, se necessário
    if column_exists?(:step_question_options, :step_question_id)
      rename_column :step_question_options, :step_question_id, :step_questions_id
    end
  end
end
