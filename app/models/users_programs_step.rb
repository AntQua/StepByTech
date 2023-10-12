class UsersProgramsStep < ApplicationRecord
  belongs_to :user
  belongs_to :program
  belongs_to :step
end
