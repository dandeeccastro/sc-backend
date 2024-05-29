class CertificateMailer < ApplicationMailer
  default from: 'venti@developer.co'
  layout 'mailer'

  def certificate_email
    @event =        params[:event]
    @user  =        params[:user]
    @certificates = params[:certificates]
    mail(to: @user.email, subject: "Certificados do Evento #{@event.name}")
  end
end
