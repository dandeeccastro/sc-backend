class TeamsController < ApplicationController
  before_action :authenticate_user
  before_action :set_team, only: %i[show update destroy]
  before_action :admin?, only: %i[index create destroy]
  before_action :admin_or_staff_leader?, only: %i[update]
  before_action :admin_or_staff?, only: %i[show]

  def index
    @teams = Team.all
    render json: TeamBlueprint.render(@teams), status: :ok
  end

  def show
    render json: TeamBlueprint.render(@team), status: :ok
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      render json: TeamBlueprint.render(@team), status: :created
    else
      render json: { error: @team.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @team.update(team_params)
      render json: TeamBlueprint.render(@team), status: :created
    else
      render json: { error: @team.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    render json: { message: 'Team destroyed!' }
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.permit(:id, user_ids: [])
  end

  def admin?
    render json: { message: 'User not admin' }, status: :unauthorized unless @current_user.admin?
  end

  def admin_or_staff?
    is_staff_from_event = @current_user.staff? && @team.users.find_by_id(@current_user.id)
    render json: { message: 'User is not event staff' }, status: :unauthorized unless @current_user.admin? || @team.users.find_by_id(@current_user)
  end

  def admin_or_staff_leader?
    is_admin = @current_user.admin?
    is_staff_leader_from_event = @current_user.staff_leader? && @current_user.runs_event?(@team.event)
    render json: { message: 'User is not event staff' }, status: :unauthorized unless is_staff_leader_from_event || is_admin
  end
end
