class ReservationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_event, only: %i[index show update create destroy]
  before_action :set_reservation, only: %i[show destroy update]

  before_action do set_permissions(user_id: @reservation&.user_id) end
  before_action only: %i[index update] do check_permissions(%i[admin staff_leader staff]) end
  before_action only: %i[show destroy] do check_permissions(%i[admin staff_leader staff owns_resource]) end
  before_action only: %i[from_user] do check_permissions(%i[admin staff_leader staff attendee]) end

  def index
    @reservations = Reservation.joins(merch: [:event]).where(merch: { event_id: @event.id }).distinct
    render json: ReservationBlueprint.render(@reservations)
  end

  def from_user
    @reservations = Reservation.where(user: @current_user)
    render json: ReservationBlueprint.render(@reservations)
  end

  def show
    render json: ReservationBlueprint.render(@reservation)
  end

  def create
    @reservation = Reservation.new(reservation_params.merge(user_id: @current_user.id))
    if @reservation.save
      AuditLogger.log_message("#{@current_user.name} criou #{@reservation}")
      render json: ReservationBlueprint.render(@reservation), status: :created
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  def update
    if @reservation.update(reservation_params)
      AuditLogger.log_message("#{@current_user.name} atualizou #{@reservation}")
      render json: ReservationBlueprint.render(@reservation), status: :ok
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless @reservation.delivered
      AuditLogger.log_message("#{@current_user.name} deletou #{@reservation}")
      @reservation.destroy
      render json: {message: "Reserva deletada com sucesso!"}, status: :ok
    else
      render json: { message: 'Reserva já entregue não pode ser deletada!' }, status: :unprocessable_entity
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end

  def reservation_params
    params.permit(:user_id, :merch_id, :delivered, :amount, options: {})
  end
end
