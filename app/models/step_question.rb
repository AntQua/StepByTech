class StepQuestion < ApplicationRecord
  belongs_to :step
  has_many :step_question_options
  enum question_type: { "Texto Livre": 0, "Multipla Escolha": 1 }

  validates :title, presence: true
  validates :question_type, presence: true
end
