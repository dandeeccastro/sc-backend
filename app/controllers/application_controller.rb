class ApplicationController < ActionController::API
  include Authenticable

  private

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @token = decode(header)
      @current_user = User.find(@token['uid'])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def admin?
    begin
      @admin = Admin.find(@current_user.id)
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: 'User needs admin permission' }, status: :unauthorized
    end
  end
end
