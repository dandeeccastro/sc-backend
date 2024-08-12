class AuthController < ApplicationController
  def login
    @user = User.find_by(cpf: auth_params[:cpf].gsub(/\D/,''))
    if @user&.authenticate(auth_params[:password])
      token = encode(uid: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.iso8601, user: UserBlueprint.render_as_hash(@user) }, status: :ok
    else
      render json: { errors: 'CPF ou senha inválidos' }, status: :unauthorized
    end
  end

  def forget
    @user = User.find_by(email: params[:email])
    if @user
      PasswordMailer.with(user: @user).reset_email.deliver_now
      render json: { message: 'E-mail de redefinição enviado com sucesso!' }, status: :ok
    else
      render json: { message: 'Não existe usuário com esse e-mail!' }, status: :unprocessable_entity
    end
  end

  def reset
    @user = User.find_signed(params[:token], purpose: 'password_reset')
    if @user
      if @user.update(password_params)
        render json: { message: 'Senha atualizada com sucesso!' }, status: :ok
      else
        render json: { message: @user.errors }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Token expirado, por favor tente novamente!' }, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.permit(:password)
  end

  def auth_params
    params.permit(:cpf, :password)
  end
end
