class DropUserAttributes < ActiveRecord::Migration[7.0]
  def change
    drop_table :user_attributes
  end
end
