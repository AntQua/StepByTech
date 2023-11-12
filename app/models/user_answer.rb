class UserAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :step_question_option
end
