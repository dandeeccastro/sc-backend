class CertificatesController < ActionController::Base
  include Authenticable
  include Loggable
  include Permissions

  before_action :authenticate_user
  before_action :set_event
  before_action :set_permissions, only: %i[emit]
  before_action :set_variables

  after_action :log_data, only: %i[emit]

  def list
    certificates = @finder.find
    render json: certificates, status: :ok
  end

  def emit
    certificates = @finder.find
    attachments = generate_certificate_files(certificates)
    case params[:emit_from]
    when 'event'
      emit_event(certificates)
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
    render json: { message: 'Certificados emitidos com sucesso!' }, status: :ok
  end

  def event; end
  def talk; end
  def staff; end

  private

  def set_event
    @event = Event.find_by(slug: params[:event_slug])
  end

  def set_variables
    case params[:emit_from]
    when 'myself'
      @finder = CertificateFinder.new(user: @current_user, criteria: 'myself')
    when 'event'
      check_permissions(%i[admin staff_leader staff])
      @finder = CertificateFinder.new(event: @event, criteria: 'event')
    when 'user'
      check_permissions(%i[admin staff_leader staff])
      @user = User.find(params[:user_id])
      @finder = CertificateFinder.new(user: @user, event: @event, criteria: 'user')
    else
      render json: { message: 'Parâmetro emit_from inválido!' }, status: :unprocessable_entity
    end
  end

  def emit_event(certificates)
    email_to_cert = Hash[certificates.map{|c|c[:email]}.uniq.collect{|c| [c,[]]}]
    certificates.each { |cert| email_to_cert[cert[:email]] << cert }
    email_to_cert.each do |email, cert|
      attachments = generate_certificate_files(cert)
      CertificateMailer.with(
        event: cert.first[:event],
        user: cert.first[:user],
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
      attachments["Certificado #{idx}.pdf"] = WickedPdf.new.pdf_from_string(pdf_data, { orientation: 'Landscape' })
      idx += 1
    end
    attachments
  end
end
