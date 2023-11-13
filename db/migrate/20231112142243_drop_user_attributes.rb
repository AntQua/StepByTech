class DropUserAttributes < ActiveRecord::Migration[7.0]
  def change
    drop_table :user_attributes, if_exists: true
  end
end
