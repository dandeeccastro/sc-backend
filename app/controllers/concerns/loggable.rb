module Loggable
  def log_data
    @event = Event.find(params[:event_id]) unless @event
    AuditLogger.log(@event, "#{@current_user.name} #{@current_user.name} chamou #{params[:action]} na controller #{params[:controller]} (parâmetros: #{params.to_unsafe_h.inspect})")
  end
end
