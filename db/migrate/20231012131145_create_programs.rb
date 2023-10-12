class CreatePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :programs do |t|
      t.string :title
      t.text :description
      t.date :registration_start_date
      t.date :registration_end_date
      t.date :begin_date
      t.date :end_date
      t.integer :registration_limit
      t.boolean :active
      t.boolean :completed

      t.timestamps
    end
  end
end
