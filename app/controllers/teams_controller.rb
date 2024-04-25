class TeamsController < ApplicationController
  before_action :authenticate_user
  before_action :set_team, only: %i[show update destroy]
  before_action :admin?, only: %i[index create destroy]
  before_action :admin_or_staff_leader?, only: %i[update]
  before_action :admin_or_staff?, only: %i[show]

  def index
    @teams = Team.all
    render json: { teams: @teams }, status: :ok
  end

  def show
    render json: { team: @team }, status: :ok
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      render json: { team: @team }, status: :created
    else
      render json: { error: @team.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @team.update(team_params)
      render json: { team: @team }, status: :created
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
    params.permit(:staff_ids, :team, :id)
  end

  def admin?
    render json: { message: 'User not admin' }, status: :unauthorized unless @current_user.admin
  end

  def admin_or_staff?
    is_staff_from_event = @current_user.staff && @team.staffs.find_by_id(@current_user.staff.id)
    render json: { message: 'User is not event staff' }, status: :unauthorized unless @current_user.admin || is_staff_from_event
  end

  def admin_or_staff_leader?
    is_staff_leader_from_event = @current_user.staff && @team.staffs.find_by_id(@current_user.staff.id)&.leader
    render json: { message: 'User is not event staff' }, status: :unauthorized unless @current_user.admin || is_staff_leader_from_event
  end
end
