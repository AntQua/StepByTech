class CreateStepQuestion < ActiveRecord::Migration[7.0]
  def change
    create_table :step_questions do |t|
      t.integer :step_id
      t.string :title
      t.integer :limit
      t.integer :question_type, default: 0
      t.timestamps
    end
  end
end
