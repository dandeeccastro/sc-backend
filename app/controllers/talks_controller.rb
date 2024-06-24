class TalksController < ApplicationController
  before_action :set_talk, only: %i[show update destroy rate]
  before_action :authenticate_user, except: %i[show]
  before_action :authorized?, only: %i[create update destroy]

  def show
    render json: TalkBlueprint.render(@talk, view: :detailed)
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
    vacancy = Vacancy.where(user_id: @current_user.id, talk_id: params[:talk_id])
    render json: { enrolled: vacancy.present?, participated: vacancy.first&.presence }, status: :ok
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
