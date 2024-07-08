class SpeakerController < ApplicationController
  before_action :authenticate_user
  before_action :set_event, only: %i[event]
  before_action :set_speaker, only: %i[destroy]

  def event
    speakers = Speaker.joins(talks: [ :event ])
    render json: SpeakerBlueprint.render(speakers)
  end

  def destroy
    @speaker.destroy
    render json: { message: 'Event deleted!' }, status: :ok
  end

  private

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
