class SpeakerController < ApplicationController
  before_action :authenticate_user
  before_action :set_event, only: %i[event]
  before_action :set_speaker, only: %i[update destroy]

  def create
    @speaker = Speaker.create(speaker_params)
    if @speaker
      render json: SpeakerBlueprint.render(@speaker), status: :created
    else
      render json: { errors: @speaker.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @speaker.update(speaker_params)
      render json: SpeakerBlueprint.render(@speaker), status: :ok
    else
      render json: { message: @peaker.errors }, status: :unprocessable_entity
    end
  end

  def event
    speakers = Speaker.where(event_id: @event.id)
    render json: SpeakerBlueprint.render(speakers, view: :detailed)
  end

  def destroy
    @speaker.destroy
    render json: { message: 'Palestrante excluído' }, status: :ok
  end

  private

  def speaker_params
    params.permit(:name, :bio, :image, :event_id, :email)
  end

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end

  def set_speaker
    @speaker = Speaker.find(params[:id])
  end

  def admin_or_staff?
    criteria = @current_user.admin? || ( (@current_user.staff? || @current_user.staff_leader?) && @current_user.runs_event?(@event) )
    render json: { message: 'Unauthorized' }, status: :unauthorized unless criteria
  end
end
