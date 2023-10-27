class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  layout "dashboard", only: [ :dashboard ]

  def home
    @programs = Program.all
  end

  def dashboard
  end

  def program_params
    params.require(:program).permit(:title, :description, :registration_start_date, :registration_end_date, :begin_date, :end_date, :registration_limit, :active, :completed)
  end
end
