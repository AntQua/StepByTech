class Step < ApplicationRecord
  belongs_to :program
  has_many :users_programs_steps
  has_many :users, through: :users_programs_steps
end
