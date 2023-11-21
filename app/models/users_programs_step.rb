class UsersProgramsStep < ApplicationRecord
  belongs_to :user
  belongs_to :program
  belongs_to :step # , optional: true  # Since step_id can be NULL ???
  has_many :users_programs_steps_submissions
  has_many :user_answers, through: :step

  enum status: { "Aguardando Aprovação": 0, "Aprovado": 1, "Reprovado": 2, "Finalizado": 3, "Desabilitado": 3 }
  def can_answer_questionnaire?
    step && status == UsersProgramsStep.statuses.key(1) && !user.answered_step?(step.id)
  end
end
