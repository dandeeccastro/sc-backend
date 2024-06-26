class UserController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate_user, only: %i[index update show destroy]
  before_action :self_or_admin?, only: %i[update destroy]
  before_action :admin?, only: %i[index]

  def index
    @users = User.all
    render json: UserBlueprint.render(@users), status: :ok
  end

  def show
    render json: UserBlueprint.render(@user), status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: UserBlueprint.render(@user), status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: UserBlueprint.render(@user), status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
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
    condition = @user.id == @current_user.id || @current_user.admin?
    render json: { errors: 'Unauthorized' }, status: :unauthorized unless condition
  end

  def user_params
    params.permit(:name, :email, :dre, :password, :cpf, :ocupation, :institution)
  end
end
