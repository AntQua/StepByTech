class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  layout "dashboard", only: [ :dashboard ]

  def home
    @programs = Program.active
    @nearest_active_program = @programs.where('registration_start_date >= ?', Date.today)
                                       .order(:registration_start_date)
                                       .first
  end


  def dashboard
    @candidate_programs = current_user
                            .users_programs_steps
                            .where.not(status: 4) # Status 4 - Desabilitado


  end

  def contacts
    # any setup needed for the contact view
  end

  def program_params
    params.require(:program).permit(:title, :description, :registration_start_date, :registration_end_date, :begin_date, :end_date, :registration_limit, :active, :completed)
  end

  def export_programs_info_excel
    @programs = Program.active.includes(steps: :users)

    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="programs_info.xlsx"'
      end
    end
  end

  def export_programs_info_pdf
    @programs = Program.active.includes(steps: :users)

    respond_to do |format|
      format.pdf do
        render pdf: "programs_info",
               template: 'pages/export_programs_info_pdf',
               formats: [:html],
               layout: 'pdf',
               orientation: 'Portrait',
               page_size: 'A4',
               disposition: "attachment"
      end
    end
  end


end
