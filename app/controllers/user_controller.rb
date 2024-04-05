class UserController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { user: @user }, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :dre, :password)
  end
end
