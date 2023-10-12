class CreateNotificationsConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications_configs do |t|
      t.text :message_template
      t.integer :type

      t.timestamps
    end
  end
end
