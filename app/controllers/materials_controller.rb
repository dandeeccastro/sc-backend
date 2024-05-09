class MaterialsController < ApplicationController
  before_action :set_material, only: %i[ show update destroy ]
  before_action :authenticate_user
  before_action :admin_or_staff?

  # POST /materials
  def create
    @material = Material.new(material_params)

    if @material.save
      render json: MaterialBlueprint.render(@material), status: :created, location: @material
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /materials/1
  def update
    if @material.update(material_params)
      render json: MaterialBlueprint.render(@material)
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  # DELETE /materials/1
  def destroy
    @material.destroy
  end

  private

  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.permit(:name, :file, :talk_id)
  end

  def admin_or_staff?
    event = Talk.find(material_params[:talk_id]).event
    admin_or_runs_event = @current_user.admin? || @current_user.runs_event?(event)
    render json: { message: 'Unauthenticated' }, status: :unauthorized unless admin_or_runs_event
  end
end
