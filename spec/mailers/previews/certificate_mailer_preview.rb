# Preview all emails at http://localhost:3000/rails/mailers/certificate
class CertificateMailerPreview < ActionMailer::Preview
  def certificate_email
    CertificateMailer.with(user: User.first, event: Event.first).certificate_email
  end
end
