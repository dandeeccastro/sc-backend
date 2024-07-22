class TypeController < ApplicationController
  before_action :authenticate_user
  before_action :set_type, only: %i[update destroy]
  before_action :admin?, only: %i[create update destroy]

  def index
    types = Type.all
    render json: TypeBlueprint.render(types), status: :ok
  end

  def create
    @type = Type.new(type_params)
    if @type.save
      render json: TypeBlueprint.render(@type), status: :created
    else
      render json: { message: @type.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @type.update(type_params)
      render json: TypeBlueprint.render(@type), status: :ok
    else
      render json: { message: @type.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @type.destroy
    render json: { message: 'Tipo deletado com sucesso!' }, status: :ok
  end

  private

  def set_type
    @type = Type.find(params[:id])
  end

  def type_params
    params.permit(:name, :color)
  end
end
