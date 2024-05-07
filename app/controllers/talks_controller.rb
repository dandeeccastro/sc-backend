class TalksController < ApplicationController
  before_action :set_talk, only: %i[show update destroy]
  before_action :authenticate_user
  before_action :authorized?, only: %i[create update destroy]

  def show
    render json: TalkBlueprint.render(@talk)
  end

  def create
    @talk = Talk.new(talk_params)

    if @talk.save
      render json: TalkBlueprint.render(@talk), status: :created, location: @talk
    else
      render json: { errors: @talk.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @talk.update(talk_params)
      render json: TalkBlueprint.render(@talk)
    else
      render json: { errors: @talk.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @talk.destroy
  end

  private

  def set_talk
    @talk = Talk.find(params[:id])
  end

  def talk_params
    params.require(:talk).permit(:title, :description, :start_date, :end_date, :event_id, :location_id)
  end

  def authorized?
    event = Event.find(talk_params[:event_id])
    admin_or_staff_from_event = @current_user.admin? || @current_user.runs_event?(event)
    render json: { message: 'Unauthorized' }, status: :unauthorized unless admin_or_staff_from_event
  end
end
