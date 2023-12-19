class EventMailer < ApplicationMailer
  def participation_email(user, event)
    @user = user
    @event = event
    formatted_date = @event.date.strftime('%d/%m/%Y') # Formats the date as DD/MM/YYYY
    mail(
      to: @user.email,
      subject: "Confirmação de participação no evento: #{@event.title} em #{formatted_date}"
    )
  end
end
