class EventMailer < ApplicationMailer
  def participation_email(user, event)
    @user = user
    @event = event
    formatted_date = @event.date.strftime('%d/%m/%Y') 
    mail(
      to: @user.email,
      subject: "Confirmação de participação no evento: #{@event.title} em #{formatted_date}"
    )
  end

  def unregistration_email(user, event)
    @user = user
    @event = event
    formatted_date = @event.date.strftime('%d/%m/%Y')

    mail(
      to: @user.email,
      subject: "Cancelamento de inscrição no evento: #{@event.title} em #{formatted_date}"
    )
  end

  def approved_program_email(user, program)
    @user = user
    @program = program

    mail(
      to: @user.email,
      subject: "StepByTech | Bem-vindo ao programa: #{@program.title}"
    )
  end

  def disapproved_program_email(user, program)
    @user = user
    @program = program

    mail(
      to: @user.email,
      subject: "StepByTech | Status da candidatura no programa: #{@program.title}"
    )
  end

  def approved_step_email(user, step)
    @user = user
    @step = step

    mail(
      to: @user.email,
      subject: "StepByTech | Bem-vindo ao step: #{@step.name}"
    )
  end

  def disapproved_step_email(user, step)
    @user = user
    @step = step

    mail(
      to: @user.email,
      subject: "StepByTech | Status da inscrição ao step: #{@step.name}"
    )
  end

  def apply_program_email(user, program)
    @user = user
    @program = program

    mail(
      to: @user.email,
      subject: "Confirmação de Recebimento da Candidatura do Programa: #{@program.title}"
    )
  end

  def submit_step_email(user, step)
    @user = user
    @step = step

    mail(
      to: @user.email,
      subject: "Confirmação de Submissão do Questionário"
    )
  end
end
