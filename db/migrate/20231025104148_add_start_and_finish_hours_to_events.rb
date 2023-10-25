class AddStartAndFinishHoursToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :hour_start, :time
    add_column :events, :hour_finish, :time
  end
end
