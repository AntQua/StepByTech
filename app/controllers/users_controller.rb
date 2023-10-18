class UsersController < ApplicationController
    # skip_before_action :authenticate_user!, only: [ :profile, :settings ]
    layout "dashboard"

    def profile
    end

    def settings
        @user = current_user
    end

    def update_settings
        @user = User.find(current_user.id)
        @user.update(user_params)
        respond_to do |format|
            format.html { redirect_to user_profile_path, notice: "Configurações salvas!!!" } 
        end
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :phone, :country, :city, :about_me)
    end
end
