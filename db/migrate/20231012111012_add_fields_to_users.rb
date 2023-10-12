class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :birth_date, :date
    add_column :users, :phone, :string
    add_column :users, :city, :string
    add_column :users, :address, :string
    add_column :users, :is_admin, :boolean
    add_column :users, :about_me, :text
    add_column :users, :gender, :integer
    add_column :users, :country, :integer
    add_column :users, :feedback, :text
    add_column :users, :show_feedback, :boolean
    add_column :users, :avatar, :string
  end
end
