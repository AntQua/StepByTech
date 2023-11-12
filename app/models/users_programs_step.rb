class UsersProgramsStep < ApplicationRecord
  belongs_to :user
  belongs_to :program
  belongs_to :step # , optional: true  # Since step_id can be NULL ???
  has_many :users_programs_steps_submissions

  enum status: { "Aguardando Aprovação": 0, "Approvado": 1, "Reprovado": 2, "Desabilitado": 3 }
  # enum status: { "Registered": 0, "Pre-Approved": 1, "Approved": 2, "Disapproved": 3, "Disabled": 4 }
end
