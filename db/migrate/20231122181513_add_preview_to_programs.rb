class AddPreviewToPrograms < ActiveRecord::Migration[7.0]
  def change
    add_column :programs, :preview, :string
  end
end
