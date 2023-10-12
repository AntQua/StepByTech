class CreateUsersProgramsSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :users_programs_steps do |t|
      t.references :user, null: false, foreign_key: true
      t.references :program, null: false, foreign_key: true
      t.date :registration_date
      t.references :step, null: false, foreign_key: true

      t.timestamps
    end
  end
end
