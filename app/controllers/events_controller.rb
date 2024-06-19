class EventsController < ApplicationController
  before_action :set_event, only: %i[update destroy]
  before_action :authenticate_user, only: %i[create update destroy]
  before_action :admin?, only: %i[create update destroy]

  def index
    @events = Event.all
    render json: EventBlueprint.render(@events)
  end

  def show
    @event = Event.find_by(slug: params[:slug])
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

  def talks
    event = Event.where('slug = :slug', { slug: event_params[:slug] })
    render json: event.schedule if event.present?
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :slug)
  end
end
