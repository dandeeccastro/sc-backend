class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy]
  before_action :authenticate_user, only: %i[index create update destroy]
  before_action :admin?, only: %i[index create update destroy]

  def index
    @events = Event.all
    render json: EventBlueprint.render(@events)
  end

  def show
    render json: EventBlueprint.render(@event)
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

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name)
  end

  def admin?
    render json: { message: 'Unauthorized' }, status: :unauthorized unless @current_user.admin?
  end
end
