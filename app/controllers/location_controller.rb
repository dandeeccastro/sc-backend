class LocationController < ApplicationController
  def index
    locations = Location.all
    render json: LocationBlueprint.render(locations), status: :ok
  end
end
