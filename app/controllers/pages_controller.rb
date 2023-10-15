class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]
  layout "dashboard", only: [ :dashboard ]

  def home
  end

  def dashboard
  end
end
