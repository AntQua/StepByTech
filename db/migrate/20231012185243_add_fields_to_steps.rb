class AddFieldsToSteps < ActiveRecord::Migration[7.0]
  def change
    add_column :steps, :dates, :date, array: true, default: []
    add_column :steps, :description, :text
    add_column :steps, :format, :string
    add_column :steps, :hour_start, :time
    add_column :steps, :hour_finish, :time
  end
end
