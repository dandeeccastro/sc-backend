class VacanciesController < ApplicationController
  before_action :set_vacancy, only: %i[ show update destroy ]
  before_action :authenticate_user

  def index
    @vacancies = Vacancy.all
    render json: VacancyBlueprint(@vacancies)
  end

  def show
    render json: VacancyBlueprint(@vacancy)
  end

  def create
    @vacancy = Vacancy.new(vacancy_params)

    if @vacancy.save
      render json: VacancyBlueprint(@vacancy), status: :created, location: @vacancy
    else
      render json: @vacancy.errors, status: :unprocessable_entity
    end
  end

  def update
    if @vacancy.update(vacancy_params)
      render json: VacancyBlueprint(@vacancy)
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
    params.require(:vacancy).permit(:presence, :staff_member_id)
  end
end
