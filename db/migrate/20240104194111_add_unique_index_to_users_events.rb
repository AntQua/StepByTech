class AddUniqueIndexToUsersEvents < ActiveRecord::Migration[7.0]
  def change
    add_index :users_events, [:user_id, :event_id], unique: true
  end
end
