class AllowNullValuesInPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :program_id, true
    change_column_null :posts, :step_id, true
    change_column_null :posts, :event_id, true
  end
end
