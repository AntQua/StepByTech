class StepQuestionPolicy < ApplicationPolicy
  def table_data?
    user.is_admin?
  end
end

