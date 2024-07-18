class ReservationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_reservation, only: %i[show destroy update]
  before_action :set_event, only: %i[index update create]
  before_action :admin_or_staff?, only: %i[index update]
  before_action :superuser_or_owner?, only: %i[show destroy]

  after_action :log_data, only: %i[create update destroy]

  def index
    @reservations = Reservation.joins(merch: [:event]).where(merch: { event_id: @event.id }).distinct
    render json: ReservationBlueprint.render(@reservations)
  end

  def show
    render json: ReservationBlueprint.render(@reservation)
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      render json: ReservationBlueprint.render(@reservation), status: :created
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  def update
    if @reservation.update(reservation_params)
      render json: ReservationBlueprint.render(@reservation), status: :ok
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end

  def reservation_params
    params.permit(:user_id, :merch_id, :delivered, :size, :amount)
  end

  def event
    Event.find(params[:event_id])
  end

  def superuser_or_owner?
    criteria = @current_user.admin? || (@current_user.runs_event?(@event) && (@current_user.staff? || @current_user.staff_leader?))
    render json: { message: 'Unauthorized' }, status: :unauthorized unless criteria || @current_user.id == @reservation.user_id
  end
end
