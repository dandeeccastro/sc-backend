class UserController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate_user, only: %i[index update show destroy]
  before_action :self_or_admin?, only: %i[update destroy]
  before_action :admin?, only: %i[index]

  def index
    @users = User.all
    render json: { users: @users }, status: :ok
  end

  def show
    render json: { user: @user }, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @attendee = Attendee.new(user: @user)
      if @attendee.save
        render json: { user: @user }, status: :ok
      else
        render json: { errors: @attendee.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @user.id == @current_user.id || @current_user.admin
      if @user.update(user_params)
        render json: { user: @user }, status: :ok
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: "You don't have permission to do this" }, status: :unauthorized
    end
  end

  def destroy
    @user.destroy
    render json: { message: 'User deleted!' }, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def self_or_admin?
    render json: { errors: 'Unauthorized' }, status: :unauthorized unless @user.id == @current_user.id || @current_user.admin
  end

  def admin?
    render json: { errors: 'Admin only' }, status: :unauthorized unless @current_user.admin
  end

  def user_params
    params.require(:user).permit(:name, :email, :dre, :password)
  end
end
