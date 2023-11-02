class StepPolicy < ApplicationPolicy
  # def index?
  #     true #
  # end
  #
  def show?
    true
  end

  def new?
    user.is_admin? # Apenas administradores podem criar novos faqs
  end
  #
  def create?
    new?
  end
  #
  def edit?
    user.is_admin? # Apenas administradores podem editar faqs
  end
  #
  def update?
    edit? # Apenas administradores
  end
  #
  def destroy?
   user.is_admin? # Apenas administradores podem excluir faqs
  end

  def table_data?
    user.is_admin?
  end
end

