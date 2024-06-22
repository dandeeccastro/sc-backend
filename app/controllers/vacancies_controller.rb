class VacanciesController < ApplicationController
  before_action :set_vacancy, only: %i[show update destroy]
  before_action :authenticate_user
  before_action :admin_or_attendee?, only: %i[schedule create destroy]
  before_action :admin_or_staff?, only: %i[index show update validate]

  def schedule
    @vacancies = Vacancy.where(user_id: @current_user.id)
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

  def participate
    vacancies_data = params[:talk_ids].map { |talk_id| { talk_id: talk_id, user_id: @current_user.id } }
    vacancies = Vacancy.create(vacancies_data)
    if vacancies
      render json: { message: 'Inscrições realizadas com sucesso' }, status: :ok
    else
      render json: vacancies.errors, status: :unprocessable_entity
    end
  end

  def validate
    talk = Talk.find(params[:talk_id])
    if talk.start_date >= DateTime.now
      Vacancy.where(talk_id: params[:talk_id], user_id: params[:presence]).update_all(presence: true)
      Vacancy.where(talk_id: params[:talk_id], user_id: params[:absence]).update_all(presence: false)
      render json: { message: 'Presenças marcadas!' }, status: :ok
    else
      render json: { message: 'Proibído marcar presença de palestra que ainda não começou!' }, status: :unprocessable_entity
    end
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
