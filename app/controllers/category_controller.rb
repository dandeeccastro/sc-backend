class CategoryController < ApplicationController
  def index
    categories = Category.all
    render json: CategoryBlueprint.render(categories), status: :ok
  end
end
