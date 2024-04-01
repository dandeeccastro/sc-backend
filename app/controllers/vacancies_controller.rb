class VacanciesController < ApplicationController
  before_action :set_vacancy, only: %i[ show update destroy ]

  # GET /vacancies
  def index
    @vacancies = Vacancy.all

    render json: @vacancies
  end

  # GET /vacancies/1
  def show
    render json: @vacancy
  end

  # POST /vacancies
  def create
    @vacancy = Vacancy.new(vacancy_params)

    if @vacancy.save
      render json: @vacancy, status: :created, location: @vacancy
    else
      render json: @vacancy.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vacancies/1
  def update
    if @vacancy.update(vacancy_params)
      render json: @vacancy
    else
      render json: @vacancy.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vacancies/1
  def destroy
    @vacancy.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vacancy
      @vacancy = Vacancy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vacancy_params
      params.require(:vacancy).permit(:presence, :staff_member_id)
    end
end
