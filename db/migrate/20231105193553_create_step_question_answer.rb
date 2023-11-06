class CreateStepQuestionAnswer < ActiveRecord::Migration[7.0]
  def change
    create_table :step_question_answers do |t|
      t.references :step_questions, null: false, foreign_key: true
      t.string :title
      t.integer :weight

      t.timestamps
    end
  end
end
