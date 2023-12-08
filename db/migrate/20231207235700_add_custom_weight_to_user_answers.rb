class AddCustomWeightToUserAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :user_answers, :custom_weight, :integer
  end
end
