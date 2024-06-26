class ApplicationController < ActionController::API
  include Authenticable

  wrap_parameters false

  private

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
