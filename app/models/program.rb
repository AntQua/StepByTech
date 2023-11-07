class Program < ApplicationRecord
  has_many :steps
  has_many :users_programs_steps
  has_many :users, through: :users_programs_steps
  has_many :program_attributes
  has_many :events
  has_many :posts
  validates :registration_limit, numericality: { only_integer: true }

  # Scopes
  scope :active, -> { where(active: true) }
end
