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
                format.html { redirect_to user_profile_path, notice: "Este e-email já está em uso por outro usuário!" }
            end
        else
            @user.update(user_params)
            if params[:user][:avatar].present?
                @user.avatar.attach(params[:user][:avatar])
            end
            @user.save
            respond_to do |format|
                format.html { redirect_to user_profile_path, notice: "Configurações salvas!!!" }
            end
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :gender, :email, :phone, :country, :city, :about_me)
    end

    # def after_sign_in_path_for(resource)
    #   dashboard_path
    # end
end
