class MerchesController < ApplicationController
  before_action :set_merch, only: %i[ show update destroy ]

  # GET /merches
  def index
    @merches = Merch.all

    render json: @merches
  end

  # GET /merches/1
  def show
    render json: @merch
  end

  # POST /merches
  def create
    @merch = Merch.new(merch_params)

    if @merch.save
      render json: @merch, status: :created, location: @merch
    else
      render json: @merch.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /merches/1
  def update
    if @merch.update(merch_params)
      render json: @merch
    else
      render json: @merch.errors, status: :unprocessable_entity
    end
  end

  # DELETE /merches/1
  def destroy
    @merch.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_merch
      @merch = Merch.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def merch_params
      params.require(:merch).permit(:name, :image, :price, :event_id)
    end
end
