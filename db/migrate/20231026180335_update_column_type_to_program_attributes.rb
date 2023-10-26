class UpdateColumnTypeToProgramAttributes < ActiveRecord::Migration[7.0]
  def change
    rename_column :program_attributes, :type, :question
  end
end
