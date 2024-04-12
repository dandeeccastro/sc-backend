class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy]
  before_action :authenticate_user, only: %i[index create update destroy]
  before_action :admin?, only: %i[index create update destroy]

  # GET /events
  def index
    @events = Event.all

    render json: { events: @events }
  end

  # GET /events/1
  def show
    render json: { event: @event }
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if @event.save
      render json: { event: @event }, status: :created, location: @event
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      render json: { event: @event }, status: :ok
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    render json: { message: 'Event deleted!' }, status: :ok
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name)
  end
end
