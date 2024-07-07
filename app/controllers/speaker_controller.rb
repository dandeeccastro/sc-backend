class SpeakerController < ApplicationController
  before_action :authenticate_user
  before_action :set_event

  def event
    speakers = Speaker.joins(talk: [ :event ])
    render json: SpeakerBlueprint.render(speakers)
  end

  private

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end

  def admin_or_staff?
    criteria = @current_user.admin? || ( (@current_user.staff? || @current_user.staff_leader?) && @current_user.runs_event?(@event) )
    render json: { message: 'Unauthorized' }, status: :unauthorized unless criteria
  end
end
