class CreateUserAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :user_attributes do |t|
      t.references :program_attribute, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
