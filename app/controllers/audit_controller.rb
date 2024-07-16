class AuditController < ApplicationController
  before_action :authenticate_user
  before_action :set_event
  before_action :staff_or_admin?

  def search
    date = DateTime.parse(params[:date])
    filename = "#{Rails.root}/log/audit/#{date.strftime '%d-%m-%Y'}.log"
    if File.exist?(filename)
      log_data = File.read(filename)
      render plain: log_data, status: :ok
    else
      render json: { message: "Log não encontrado para o dia #{params[:date]}!" }, status: 404
    end
  end

  private

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end

  def staff_or_admin?
    criteria = @current_user.admin? || (@current_user.runs_event?(@event) && (@current_user.staff? || @current_user.staff_member?))
    render json: { message: 'Unauthorized' } unless criteria
  end
end
