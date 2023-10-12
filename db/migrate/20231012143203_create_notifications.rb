class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.references :notifications_config, null: false, foreign_key: true

      t.timestamps
    end
  end
end
