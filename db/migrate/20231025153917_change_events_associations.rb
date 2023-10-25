class ChangeEventsAssociations < ActiveRecord::Migration[7.0]
  def change
    change_column_null :events, :program_id, true
    change_column_null :events, :step_id, true
  end
end
