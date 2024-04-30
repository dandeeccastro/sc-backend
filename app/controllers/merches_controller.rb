class MerchesController < ApplicationController
  before_action :set_merch, only: %i[show update destroy]
  before_action :authenticate_user
  before_action :staff_or_admin?, only: %i[create update destroy]

  def index
    @merches = Merch.all
    render json: MerchBlueprint.render(@merches), status: :ok
  end

  def show
    render json: MerchBlueprint.render(@merch), status: :ok
  end

  def create
    @merch = Merch.new(merch_params)

    if @merch.save
      render json: MerchBlueprint.render(@merch), status: :created
    else
      render json: @merch.errors, status: :unprocessable_entity
    end
  end

  def update
    if @merch.update(merch_params)
      render json: MerchBlueprint.render(@merch), status: :ok
    else
      render json: @merch.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @merch.destroy
    render json: { message: 'Merch deleted!' }, status: :ok
  end

  private

  def set_merch
    @merch = Merch.find(params[:id])
  end

  def merch_params
    params.permit(:name, :image, :price, :event_id)
  end

  def staff_or_admin?
    staff = @current_user.staff
    team = Event.find(merch_params[:event_id])&.team
    is_team_member = team&.staffs&.find(staff.id)
    render json: { message: 'Unauthorized!' }, status: :unauthorized unless @current_user.admin || is_team_member
  end
end
