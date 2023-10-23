class UsersProgramsStep < ApplicationRecord
  belongs_to :user
  belongs_to :program
  belongs_to :step # , optional: true  # Since step_id can be NULL ???
  has_many :users_programs_steps_submissions

  enum status: { applied: 0, under_review: 1, accepted: 2, rejected: 3 }
end
