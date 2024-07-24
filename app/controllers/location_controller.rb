class LocationController < ApplicationController
  before_action :authenticate_user
  before_action :set_location, only: %i[update destroy]
  before_action :admin_or_staff_leader_perms, only: %i[create update destroy]

  def index
    locations = Location.all
    render json: LocationBlueprint.render(locations), status: :ok
  end

  def create
    location = Location.new(location_params)
    if location.save
      render json: LocationBlueprint.render(location), status: :created
    else
      render json: { message: location.errors }, status: :unprocessable_entity
    end
  end
  
  def update
    if @location.update(location_params)
      render json: LocationBlueprint.render(@location), status: :created
    else
      render json: { message: @location.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    render json: { message: 'Localização deletada com sucesso!'}, status: :ok
  end

  private

  def location_params
    params.permit(:id, :name)
  end

  def set_location
    @location = Location.find(params[:id])
  end

  def admin_or_staff_leader_perms
    render json: { message: 'Sem permissão para criar local!' }, status: :unauthorized unless @current_user.admin? || @current_user.staff_leader?
  end
end
