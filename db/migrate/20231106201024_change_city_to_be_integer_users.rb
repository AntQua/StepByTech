class ChangeCityToBeIntegerUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :city, :integer, using: 'city::integer'
  end
end
