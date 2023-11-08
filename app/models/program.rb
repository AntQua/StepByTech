class Program < ApplicationRecord
  has_many :steps
  has_many :users_programs_steps
  has_many :users, through: :users_programs_steps
  has_many :program_attributes
  has_many :events
  has_many :posts
  has_many :step_questions, through: :steps
  has_many :step_question_options, through: :step_questions
  validates :registration_limit, numericality: { only_integer: true }

  has_one_attached :image  # This is for the Active Storage association for the user's avatar.
end
