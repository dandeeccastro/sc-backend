class EventsController < ApplicationController
  before_action :attempt_to_authenticate_user, only: %i[index]
  before_action :authenticate_user, only: %i[create update destroy validate]
  before_action :set_event_by_slug, only: %i[show validate publish]
  before_action :set_event, only: %i[update destroy]

  before_action only: %i[create update destroy] do
    set_permissions
    check_permissions(%i[admin])
  end

  def index
    @events = list_events_based_on_user_permissions
    render json: EventBlueprint.render(@events)
  end

  def show
    render json: EventBlueprint.render(@event, view: :event)
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: EventBlueprint.render(@event), status: :created, location: @event
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: EventBlueprint.render(@event), status: :ok
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    render json: { message: 'Event deleted!' }, status: :ok
  end

  def validate
    render json: @current_user.runs_event?(@event), status: :ok
  end

  def publish
    @event.update(published: !@event.published)
    render json: @event, status: :ok
  end

  private

  def set_event_by_slug
    @event = Event.find_by(slug: params[:slug])
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.permit(:id, :name, :slug, :start_date, :end_date, :registration_start_date, :banner, :team_id, :cert_background)
  end

  def list_events_based_on_user_permissions
    if @current_user.nil?
      Event.where(published: true)
    elsif @current_user.attendee?
      Event.where(published: true)
    elsif @current_user.staff? || @current_user.staff_leader?
      Event.where(team: @current_user.teams).or(Event.where(published: true))
    elsif @current_user.admin?
      Event.all
    end
  end
end
