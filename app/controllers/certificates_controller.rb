class CertificatesController < ActionController::Base
  def list
    finder = CertificateFinder.new(user_id: params[:user_id], event_id: params[:event_id])
    certificates = finder.all
    render json: certificates, status: :ok
  end

  def emit
    finder = CertificateFinder.new(user_id: params[:user_id], event_id: params[:event_id])
    certificates = finder.all
    CertificateMailer.with(
      event_id: params[:event_id],
      user_id: params[:user_id],
      certificates: certificates
    ).certificate_email.deliver_now
  end

  def event
    set_variables_from_params
  end

  def talk
    set_variables_from_params
    @talk = Talk.find(params[:talk_id])
  end

  def staff
    set_variables_from_params
  end

  private

  def set_variables_from_params
    @event = Event.find(params[:event_id])
    @user = User.find(params[:user_id])
  end
end
