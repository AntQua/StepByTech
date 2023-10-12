class CreateProgramAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :program_attributes do |t|
      t.integer :weight
      t.references :program, null: false, foreign_key: true
      t.integer :type

      t.timestamps
    end
  end
end
