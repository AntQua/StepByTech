class CreateUsersEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :users_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.boolean :participated

      t.timestamps
    end
  end
end
