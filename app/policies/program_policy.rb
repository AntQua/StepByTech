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

    def candidates_table_data?
      user.is_admin?
    end

    def update_step_candidate?
      user.is_admin?
    end

    def apply?
      true
    end
    def apply_to_program?
      true
    end

    def table_data?
      user.is_admin?
    end

    def approve?
      user.is_admin
    end

    def disapprove?
      user.is_admin
    end
end
