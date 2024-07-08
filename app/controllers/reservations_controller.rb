class ReservationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_reservation, only: %i[show destroy]
  before_action :set_event, only: %i[index]
  before_action :staff_or_admin?, only: %i[index]
  before_action :has_permission?, only: %i[show]

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
    params.permit(:user_id, :merch_id)
  end

  def event
    Event.find(params[:event_id])
  end

  def has_permission?
    is_admin = @current_user.admin?
    is_staff_from_event = @current_user.runs_event?(event)
    owns_reservation = @current_user.id == @reservation.user_id

    render json: { message: 'Unauthorized' }, status: :unauthorized unless is_admin || is_staff_from_event || owns_reservation
  end

  def staff_or_admin?
    is_admin = @current_user.admin?
    is_staff_from_event = @current_user.runs_event?(event)

    render json: { message: 'Unauthorized' }, status: :unauthorized unless is_admin || is_staff_from_event
  end
end
