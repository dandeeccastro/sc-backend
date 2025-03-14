class AuditController < ApplicationController
  before_action :authenticate_user
  before_action :set_event

  before_action :set_permissions
  before_action do check_permissions(%i[admin staff_leader staff]) end

  def search
    date = DateTime.parse(params[:date])
    filename = "#{Rails.root}/log/audit/#{date.strftime '%d-%m-%Y'}.log"
    if File.exist?(filename)
      log_data = AuditLogger.get_log(@event)
      render plain: log_data, status: :ok
    else
      render json: { message: "Log não encontrado para o dia #{params[:date]}!" }, status: :not_found
    end
  end

  private

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end
end
