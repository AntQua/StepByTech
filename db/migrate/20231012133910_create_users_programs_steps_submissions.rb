class CreateUsersProgramsStepsSubmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :users_programs_steps_submissions do |t|
      t.references :users_programs_step, null: false, foreign_key: true
      t.string :content
      t.date :date

      t.timestamps
    end
  end
end
