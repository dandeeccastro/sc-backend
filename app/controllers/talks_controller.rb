class TalksController < ApplicationController
  before_action :set_talk, only: %i[show update destroy]
  before_action :authenticate_user
  before_action :authorized?, only: %i[create update destroy]

  # GET /talks/1
  def show
    render json: { talk: @talk }
  end

  # POST /talks
  def create
    @talk = Talk.new(talk_params)

    if @talk.save
      render json: { talk: @talk }, status: :created, location: @talk
    else
      render json: { errors: @talk.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /talks/1
  def update
    if @talk.update(talk_params)
      render json: { talk: @talk }
    else
      render json: { errors: @talk.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /talks/1
  def destroy
    @talk.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_talk
    @talk = Talk.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def talk_params
    params.require(:talk).permit(:title, :description, :start_date, :end_date, :event_id, :location_id)
  end

  # TODO: apply the Law of Demeter here to make it consise
  def authorized?
    is_admin = @current_user.admin.present?
    staff = @current_user.staff
    team = Event.find(talk_params[:event_id])&.team
    is_team_member = team&.staffs&.find(staff.id)
    if !is_admin && !is_team_member
      render json: { message: 'Not allowed to do that!' }, status: :unauthorized
    end
  end
end
