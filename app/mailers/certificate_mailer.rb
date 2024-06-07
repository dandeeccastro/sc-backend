class CertificateMailer < ApplicationMailer
  def certificate_email
    @event =        params[:event]
    @user  =        params[:user]

    params[:attachments].each_key do |filename|
      attachments[filename] = params[:attachments][filename]
    end
    mail(to: @user.email, subject: "Certificado do Evento #{@event.name}")
  end
end
