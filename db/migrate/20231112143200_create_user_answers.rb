class CreateUserAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :step_question_option, null: false, foreign_key: true
      t.string :text
      t.timestamps
    end
  end
end
