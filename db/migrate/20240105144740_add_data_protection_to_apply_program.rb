class AddDataProtectionToApplyProgram < ActiveRecord::Migration[7.0]
  def change
    add_column :users_programs_steps, :data_protection_usage, :boolean
    add_column :users_programs_steps, :data_protection_divulgation, :boolean
    add_column :users_programs_steps, :data_protection_evaluation, :boolean
    add_column :users_programs_steps, :data_protection_terms, :boolean
  end
end
