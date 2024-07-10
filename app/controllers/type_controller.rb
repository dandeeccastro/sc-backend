class TypeController < ApplicationController
  def index
    types = Type.all
    render json: TypeBlueprint.render(types), status: :ok
  end
end
