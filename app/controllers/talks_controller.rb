class TalksController < ApplicationController
  before_action :authenticate_user, only: %i[create update destroy status staff_show]
  before_action :set_talk, only: %i[show update destroy rate status staff_show]
  before_action :set_event, only: %i[index create destroy update]

  before_action :set_permissions
  before_action only: %i[create update destroy staff_show] do check_permissions(%i[admin staff_leader staff]) end

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
    was_present = Vacancy.where(user_id: @current_user.id, talk_id: @talk.id, presence: true).exists?
    if was_present
      rating = Rating.find_by(user_id: @current_user.id, talk_id: @talk.id)
      if rating
        rating.update(score: params[:score])
        render json: { message: 'Avaliação atualizada!' }, status: :ok
      else
        Rating.create(score: params[:score], user_id: @current_user.id, talk_id: @talk.id)
        render json: { message: 'Avaliação registrada!' }, status: :ok
      end
    else
      render json: { message: 'Não pode avaliar palestra que não participou' }, status: :unprocessable_entity
    end
  end

  def status
    vacancy = Vacancy.find_by(user_id: @current_user.id, talk_id: @talk.id)
    render json: { enrolled: vacancy.present?, participated: vacancy.presence }, status: :ok
  end

  private

  def set_talk
    @talk = Talk.find(params[:id])
  end

  def set_event
    if params[:event_slug]
      @event = Event.find_by(slug: params[:event_slug])
    elsif params[:event_id]
      @event = Event.find(params[:event_id])
    else
      @event = Event.find(@talk.event_id)
    end
  end

  def talk_params
    params.permit(:id, :title, :description, :start_date, :end_date, :vacancy_limit, :event_id, :location_id, :type_id, speaker_ids: [], category_ids: [])
  end
end
