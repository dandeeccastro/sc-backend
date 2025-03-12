class MerchesController < ApplicationController
  before_action :authenticate_user, except: %i[show]
  before_action :set_event
  before_action :set_merch, only: %i[show update destroy]

  before_action only: %i[create update destroy] do
    set_permissions
    check_permissions(%i[admin staff_leader staff])
  end

  after_action :log_data, only: %i[create update destroy]

  def index
    @merches = Merch.where(event_id: @event.id)
    if @current_user&.admin? || @current_user&.staff_leader? || @current_user&.staff?
      render json: MerchBlueprint.render(@merches, view: :staff), status: :ok
    else
      render json: MerchBlueprint.render(@merches), status: :ok
    end
  end

  def show
    render json: MerchBlueprint.render(@merch), status: :ok
  end

  def create
    @merch = Merch.new(merch_params)

    if @merch.save
      @event = Event.find(merch_params[:event_id])
      AuditLogger.log(@event, "Staff #{@current_user.name} criou mercadoria #{merch_params[:name]}")
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
    render json: { message: 'Mercadoria deletada com sucesso!' }, status: :ok
  end

  private

  def set_merch
    @merch = Merch.find(params[:id])
  end

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end

  def merch_params
    params.permit(:name, :image, :price, :event_id, :stock, :limit,  custom_fields: {})
  end
end
