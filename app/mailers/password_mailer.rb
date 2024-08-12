class PasswordMailer < ApplicationMailer
  def reset_email
    @user = params[:user]
    @token = @user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)
    mail(to: @user.email, subject: 'Venti: Redefinição de Senha')
  end
end
