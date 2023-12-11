class AddColumnEvaluatedToUserProgramsStep < ActiveRecord::Migration[7.0]
  def change
    add_column :users_programs_steps, :evaluated, :boolean,  :default => false
  end
end
