class ApplicationController < ActionController::API
  include Authenticable

  wrap_parameters false

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
    render json: { message: 'User is not admin' }, status: :unauthorized unless @current_user.admin?
  end

  def admin_or_staff?
    condition = @current_user.admin? || @current_user.runs_event?(@event)
    render json: { message: 'User is not event staff' }, status: :unauthorized unless condition
  end

  def admin_or_staff_leader?
    condition = @current_user.admin? || @current_user.staff_leader? && @current_user.runs_event?(@event)
    render json: { message: 'User is not event staff' }, status: :unauthorized unless condition
  end
end
