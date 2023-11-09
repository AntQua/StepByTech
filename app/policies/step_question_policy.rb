class StepQuestionPolicy < ApplicationPolicy
  def new?
    user.is_admin?
  end

  def create?
    user.is_admin?
  end

  def table_data?
    user.is_admin?
  end

  def save?
    user.is_admin?
  end
end

