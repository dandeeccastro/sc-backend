class CertificatesController < ActionController::Base
  include Authenticable

  before_action :authenticate_user
  before_action :set_variables

  def list
    certificates = @finder.find
    render json: certificates, status: :ok
  end

  def emit
    case params[:emit_from]
    when 'event'
      emit_event
    when 'user'
      CertificateMailer.with(
        event: @event,
        user: @user,
        attachments: attachments
      ).certificate_email.deliver_now
    when 'myself'
      CertificateMailer.with(
        event: @event,
        user: @current_user,
        attachments: attachments
      ).certificate_email.deliver_now
    end
  end

  def event; end
  def talk; end
  def staff; end

  private

  def set_variables
    case params[:emit_from]
    when 'myself'
      @finder = CertificateFinder.new(user: @current_user, criteria: 'user')
    when 'event'
      admin_or_staff?
      @finder = CertificateFinder.new(event: Event.find_by(slug: params[:event_slug]), criteria: 'event')
    when 'user'
      admin_or_staff?
      @user = User.find(params[:user_id])
      @finder = CertificateFinder.new(user: @user, criteria: 'user')
    else
      render json: { message: 'Parâmetro emit_from inválido!' }, status: :unprocessable_entity
    end
  end

  def emit_event(certificates)
    email_to_cert = Hash[certificates.map(&:email)].uniq.collect{ |v| [v, []]}
    certificates.each { |cert| email_to_cert[cert.email] << cert }
    email_to_cert.each do |email, cert|
      CertificateMailer.with(
        event: cert.event,
        user: cert.user,
        attachments: attachments
      ).certificate_email.deliver_now
    end
  end

  def generate_certificate_files(certificate_data)
    idx = 0
    attachments = {}
    certificate_data.each do |cert|
      case cert[:type]
      when :talk_participation
        pdf_data = render_to_string :talk, locals: cert
      when :attendee_participation
        pdf_data = render_to_string :event, locals: cert
      when :staff_participation
        pdf_data = render_to_string :staff, locals: cert
      end
      attachments["Certificado #{idx}.pdf"] = WickedPdf.new.pdf_from_string(pdf_data)
      idx += 1
    end
    attachments
  end

  def admin_or_staff?
    criteria = @current_user.admin? || (@current_user.runs_event?(@event) && (@current_user.staff? || @current_user.staff_leader?))
    render json: { message: 'Unauthorized' } unless criteria
  end
end
