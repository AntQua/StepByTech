class AddColumnNameToProgramAttributes < ActiveRecord::Migration[7.0]
  def change
    add_column :program_attributes, :name, :string
    change_column :program_attributes, :type, :string
  end
end
