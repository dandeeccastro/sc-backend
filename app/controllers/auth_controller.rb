class AuthController < ApplicationController
  def login
    @user = User.find_by(cpf: auth_params[:cpf])
    if @user&.authenticate(auth_params[:password])
      token = encode(uid: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%d/%m/%Y %H:%M") }, status: :ok
    else
      render json: { errors: 'Wrong email and/or password' }, status: :unauthorized
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
