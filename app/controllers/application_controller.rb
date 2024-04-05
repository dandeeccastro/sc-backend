class ApplicationController < ActionController::API
  include Authenticable

  attr_reader :current_user

  private

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @token = Authenticable.decode(header)
      @current_user = User.find(@decoded[:uid])
    rescue ActiveRecord::RecordNotFound => exception
      render json: { errors: exception.message }, status: :unauthorized
    rescue JWT::DecodeError => expection
      render json: { errors: exception.message }, status: :unauthorized
    end
  end
end
