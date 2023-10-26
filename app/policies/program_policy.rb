class ProgramPolicy < ApplicationPolicy
    # def index?
    #     true # Todos os usuários podem acessar a lista de programas
    # end
    #
    def show?
      true # Todos os usuários podem ver detalhes de um programa
    end

    def detail?
      true
    end
        
    def new?
      user.is_admin? # Apenas administradores podem criar novos programas
    end
    #
    def create?
      new?
    end
    #
    def edit?
      user.is_admin? # Apenas administradores podem editar programas
     end
    #
    def update?
      edit? # Apenas administradores
    end
    #
    def destroy?
     user.is_admin? # Apenas administradores podem excluir programas
    end
end
