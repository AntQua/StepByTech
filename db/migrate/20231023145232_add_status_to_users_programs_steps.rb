class AddStatusToUsersProgramsSteps < ActiveRecord::Migration[7.0]
  def change
    add_column :users_programs_steps, :status, :integer, default: 0
  end
end
