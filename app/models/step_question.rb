class StepQuestion < ApplicationRecord
  belongs_to :step
  has_many :step_question_options, :dependent => :destroy
  enum question_type: { "Texto Livre": 0, "Multipla Escolha": 1 }

  validates :title, presence: true
  validates :question_type, presence: true

  def title_format
    question_type == StepQuestion.question_types.key(1) ? "#{title} (máximo de #{limit} resposta(s))" : "#{title} (máximo de #{limit} caractere(s))"
  end
end
