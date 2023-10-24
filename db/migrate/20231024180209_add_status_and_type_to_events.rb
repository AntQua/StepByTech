class AddStatusAndTypeToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :status, :integer unless column_exists? :events, :status
    add_column :events, :type, :integer unless column_exists? :events, :type
  end
end
