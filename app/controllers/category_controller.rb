class CategoryController < ApplicationController
  before_action :authenticate_user
  before_action :set_event
  before_action :set_category, only: %i[update]
  before_action :admin_or_staff?, only: %i[create update destroy]

  def index
    categories = Category.where(event_id: @event.id)
    render json: CategoryBlueprint.render(categories), status: :ok
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: CategoryBlueprint.render(@category), status: :created
    else
      render json: { message: @category.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: CategoryBlueprint.render(@category), status: :ok
    else
      render json: { message: @category.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy!
    render json: { message: 'Categoria removida com sucesso' }, status: :ok
  end

  private

  def category_params
    params.merge(event_id: @event.id).permit(:name, :color, :event_id)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end
end
