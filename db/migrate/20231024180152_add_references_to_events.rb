class AddReferencesToEvents < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :program, null: false, foreign_key: true
    add_reference :events, :step, null: false, foreign_key: true
  end
end
