class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.references :program, null: false, foreign_key: true
      t.string :name
      t.integer :step_order
      t.boolean :submission
      t.boolean :active

      t.timestamps
    end
  end
end
