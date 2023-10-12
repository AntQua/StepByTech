class Program < ApplicationRecord
  has_many :steps
  has_many :users_programs_steps
  has_many :users, through: :users_programs_steps
  has_many :program_attributes
end
