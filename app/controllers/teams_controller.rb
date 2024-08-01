class TeamsController < ApplicationController
  before_action :authenticate_user
  before_action :set_team, only: %i[show update destroy]
  before_action :set_event_by_slug, only: %i[event update]

  before_action :set_permissions
  before_action only: %i[index create destroy] do check_permissions(%i[admin]) end
  before_action only: %i[update] do check_permissions(%i[admin staff_leader]) end
  before_action only: %i[show event] do check_permissions(%i[admin staff_leader staff]) end

  def index
    @teams = Team.all
    render json: TeamBlueprint.render(@teams), status: :ok
  end

  def event
    @team = Team.find_by(event_id: @event.id)
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

  def set_event_by_slug
    @event = Event.find_by(slug: params[:slug])
  end

  def team_params
    params.permit(:id, user_ids: [])
  end
end
