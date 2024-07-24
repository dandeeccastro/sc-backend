class VacanciesController < ApplicationController
  before_action :authenticate_user

  before_action :set_vacancy, only: %i[destroy]
  before_action :set_event

  before_action :owns_vacancy?, only: %i[destroy]
  before_action :admin_or_attendee?, only: %i[schedule destroy]
  before_action :admin_or_staff?, only: %i[validate]

  after_action :log_data, only: %i[create update destroy validate]

  def schedule
    talks = Event.find_by(slug: params[:event_slug]).talks
    @vacancies = Vacancy.where(user_id: @current_user.id, talk_id: talks.map(&:id))
    render json: TalkFormatter.format_vacancies_into_schedule(@vacancies), status: :ok
  end

  def destroy
    @vacancy.destroy
    render json: { message: "Você removeu sua inscrição para #{@vacancy.talk.title} com sucesso!" }, status: :ok
  end

  def participate
    if @event.registration_start_date > DateTime.now
      render json: { message: 'Inscrições ainda não foram abertas!' }, status: :unprocessable_entity
    else
      vacancies_data = params[:talk_ids].map { |talk_id| { talk_id: talk_id, user_id: @current_user.id } }
      vacancies = Vacancy.create(vacancies_data)
      render json: { 
        confirmed: VacancyBlueprint.render_as_json(vacancies.select { |v| v.valid? }),
        denied: VacancyBlueprint.render_as_json(vacancies.select { |v| v.invalid? }),
      }, status: :ok
    end
  end

  def validate
    talk = Talk.find(params[:talk_id])
    if talk.end_date >= DateTime.now
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

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end

  def vacancy_params
    params.permit(:presence, :talk_id, :user_id)
  end

  def owns_vacancy?
    render json: { message: 'Você não pode deletar uma vaga que não te pertence' }, status: :unauthorized unless @vacancy.user_id == @current_user.id
  end

  def admin_or_attendee?
    render json: { message: 'Unauthorized' }, status: :unauthorized unless @current_user.admin? || @current_user.attendee?
  end
end
