class ReservationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_reservation, only: %i[show destroy]

  def index
    @reservations = Reservation.all
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

  def destroy
    @reservation.destroy
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.permit(:user_id, :merch_id)
  end

  def event
    Event.find(params[:event_id])
  end

  def has_permission?
    is_admin = @current_user.admin?
    is_staff_from_event = @current_user.runs_event?(event)
    owns_reservation = @current_user.id == reservation_params[:user_id]

    render json: { message: 'Unauthorized' }, status: :unauthorized unless is_admin || is_staff_from_event || owns_reservation
  end
end
