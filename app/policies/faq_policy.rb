class FaqPolicy < ApplicationPolicy
  # def index?
  #     true #
  # end
  #
  def show?
    true
  end

  def general?
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
end
