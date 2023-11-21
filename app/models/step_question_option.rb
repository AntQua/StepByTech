class StepQuestionOption < ApplicationRecord
  belongs_to :step_question
  has_many :user_answers, dependent: :destroy
end
