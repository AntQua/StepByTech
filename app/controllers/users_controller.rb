class UsersController < ApplicationController
    # skip_before_action :authenticate_user!, only: [ :profile, :settings ]
    layout "dashboard"

    def profile
    end

    def settings
    end
end
