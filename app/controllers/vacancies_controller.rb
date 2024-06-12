class VacanciesController < ApplicationController
  before_action :set_vacancy, only: %i[show update destroy]
  before_action :authenticate_user
  before_action :admin_or_attendee?, only: %i[create destroy]
  before_action :admin_or_staff?, only: %i[index show update]

  def user
    @vacancies = Vacancy.where('user_id = :user_id', { user_id: params[:user_id] })
    render json: VacancyBlueprint.render(@vacancies)
  end

  def talk
    @vacancies = Vacancy.where('talk_id = :talk_id', { talk_id: params[:talk_id] })
    render json: VacancyBlueprint.render(@vacancies)
  end

  def show
    render json: VacancyBlueprint.render(@vacancy)
  end

  def create
    @vacancy = Vacancy.new(vacancy_params)

    if @vacancy.save
      render json: VacancyBlueprint.render(@vacancy), status: :created, location: @vacancy
    else
      render json: @vacancy.errors, status: :unprocessable_entity
    end
  end

  def update
    if @vacancy.update(vacancy_params)
      render json: VacancyBlueprint.render(@vacancy)
    else
      render json: @vacancy.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @vacancy.destroy
  end

  private

  def set_vacancy
    @vacancy = Vacancy.find(params[:id])
  end

  def vacancy_params
    params.permit(:presence, :talk_id, :user_id)
  end

  def admin_or_staff?
    event = Talk.find(vacancy_params[:talk_id]).event
    render json: { message: 'Unauthorized' } unless @current_user.admin? || @current_user.runs_event?(event)
  end

  def admin_or_attendee?
    render json: { message: 'Unauthorized' } unless @current_user.admin? || @current_user.attendee?
  end
end
