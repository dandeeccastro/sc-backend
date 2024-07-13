class TalksController < ApplicationController
  before_action :authenticate_user, only: %i[create update destroy status]
  before_action :set_talk, only: %i[show update destroy rate status]
  before_action :set_event, only: %i[index destroy]
  before_action :authorized?, only: %i[create update destroy]

  def index
    talks = Talk.where(event_id: @event.id)
    render json: TalkBlueprint.render(talks), status: :ok
  end

  def show
    render json: TalkBlueprint.render(@talk, view: :detailed)
  end

  def staff_show
    render json: TalkBlueprint.render(@talk, view: :staff)
  end

  def create
    @talk = Talk.new(talk_params)

    if @talk.save
      render json: TalkBlueprint.render(@talk, view: :detailed), status: :created, location: @talk
    else
      render json: { errors: @talk.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @talk.update(talk_params)
      render json: TalkBlueprint.render(@talk, view: :detailed)
    else
      render json: { errors: @talk.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @talk.destroy
    render json: { message: 'Palestra excluída' }, status: :ok
  end

  def rate
    rating = Rating.find_by(user_id: @current_user.id, talk_id: @talk.id)
    if rating
      rating.update(score: params[:score])
      render json: { message: 'Avaliação atualizada!' }, status: :ok
    else
      Rating.create(score: params[:score], user_id: @current_user.id, talk_id: @talk.id)
      render json: { message: 'Avaliação registrada!' }, status: :ok
    end
  end

  def status
    vacancy = Vacancy.where(user_id: @current_user.id, talk_id: @talk.id)
    render json: { enrolled: vacancy.present?, participated: vacancy.presence }, status: :ok
  end

  private

  def set_talk
    @talk = Talk.find(params[:id])
  end

  def set_event
    if params[:event_slug]
      @event = Event.find_by(slug: params[:event_slug])
    elsif
      @event = Event.find(params[:event_id])
    else
      @event = Event.find(@talk.event_id)
    end
  end

  def talk_params
    params.permit(:id, :title, :description, :start_date, :end_date, :event_id, :location_id, :speaker_id, :type_id, category_ids: [])
  end

  def authorized?
    criteria = @current_user.admin? || (@current_user.runs_event?(@event) && (@current_user.staff? || @current_user.staff_leader?))
    render json: { message: 'Unauthorized' }, status: :unauthorized unless criteria
  end
end
