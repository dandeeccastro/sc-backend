class CertificateMailer < ApplicationMailer
  def certificate_email
    @subject  = params[:subject]
    @receiver = params[:receiver]
    @reason   = params[:reason]

    params[:attachments].each do |data|
      attachments[data[:filename]] = data[:data]
    end
    mail(to: params[:email], subject: params[:subject])
  end
end
