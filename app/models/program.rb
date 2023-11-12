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

  def registration_open?
    current_date = Date.today
    current_date >= registration_start_date && current_date <= registration_end_date
  end

  def is_candidate?(user_id)
    users.exists?(id: user_id)
  end

  def next_step_name(current_step_order)
    next_step = steps.where(step_order: current_step_order + 1).first
    next_step != nil ? next_step.name : ""
  end
end
