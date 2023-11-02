class UsersController < ApplicationController
    before_action :authenticate_user!
    layout "dashboard"

    def profile
    end

    def settings
        @user = current_user
    end

    def update_settings
        @user = User.find(current_user.id)
        if user_params[:email] != @user.email && User.exists?(email: user_params[:email])
            respond_to do |format|
                format.html { redirect_to user_profile_path, notice: "Este e-email ja esta em uso por outro usuário!" }
            end
        else 
            @user.update(user_params)
            respond_to do |format|
                format.html { redirect_to user_profile_path, notice: "Configurações salvas!!!" } 
            end
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :phone, :country, :city, :about_me, :avatar)
    end

    # def after_sign_in_path_for(resource)
    #   dashboard_path
    # end
end
