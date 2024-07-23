class ApplicationController < ActionController::API
  include Authenticable

  wrap_parameters false
  attr_reader :current_user

  private

  def admin?
    render json: { message: "#{current_user.name} não tem permissão de administrador!" }, status: :unauthorized unless current_user.admin?
  end

  def admin_or_staff?
    condition = current_user.admin? || (current_user.runs_event?(@event) && (current_user.staff? || current_user.staff_leader?))
    render json: { message: "#{current_user.name} não tem permissão de membro de equipe para o evento #{@event.name}" }, status: :unauthorized unless condition
  end

  def admin_or_staff_leader?
    condition = current_user.admin? || (current_user.staff_leader? && current_user.runs_event?(@event))
    render json: { message: "#{current_user.name} não tem permissão de líder de equipe para o evento #{@event.name}" }, status: :unauthorized unless condition
  end

  def log_data
    @event = Event.find(params[:event_id]) unless @event
    AuditLogger.log(@event, "#{current_user.name} #{current_user.name} chamou #{params[:action]} na controller #{params[:controller]} (parâmetros: #{params.to_unsafe_h.inspect})")
  end
end
