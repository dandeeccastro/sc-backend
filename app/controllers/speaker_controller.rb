class SpeakerController < ApplicationController
  before_action :authenticate_user
  before_action :set_event, only: %i[event create update destroy]
  before_action :set_speaker, only: %i[update destroy]

  before_action :admin_or_staff?, only: %i[create update destroy]

  after_action :log_data, only: %i[create update destroy]

  def event
    speakers = Speaker.where(event_id: @event.id)
    render json: SpeakerBlueprint.render(speakers, view: :detailed)
  end

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
end
