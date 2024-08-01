class UserController < ApplicationController
  before_action :authenticate_user, except: %i[create]

  before_action :set_event, only: %i[event index show update]
  before_action :set_user, only: %i[show update destroy]

  before_action except: %i[create] do set_permissions(user_id: @user&.id) end
  before_action only: %i[index] do check_permissions(%i[admin staff_leader]) end
  before_action only: %i[show update] do check_permissions(%i[admin staff_leader owns_resource]) end
  before_action only: %i[destroy] do check_permissions(%i[admin owns_resource]) end
  before_action only: %i[event] do check_permissions(%i[admin staff_leader staff]) end

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
    if @permissions[:admin]
      final_params = admin_params
    elsif @permissions[:staff_leader]
      final_params = staff_params
    elsif @permissions[:owns_resource]
      final_params = user_params
    end

    if @user.update(final_params)
      render json: UserBlueprint.render(@user), status: :ok
    else
      render json: { message: @user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    render json: { message: 'Usuário deletado com sucesso!' }, status: :ok
  end

  def event
    users = User.joins(vacancies: { talk: [:event]}).where(event: { id: @event.id })
    render json: UserBlueprint.render(users), status: :ok
  end

  def is_admin
    render json: @current_user.admin?, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end

  def user_params
    params.permit(:id, :name, :email, :dre, :password, :cpf, :ocupation, :institution)
  end

  def admin_params
    params.permit(:id, :name, :email, :dre, :password, :cpf, :ocupation, :institution, :permissions)
  end

  def staff_params
    filtered_permissions = params[:permissions].to_i & 0b01111
    params.merge(permissions: filtered_permissions).permit(:permissions)
  end
end
