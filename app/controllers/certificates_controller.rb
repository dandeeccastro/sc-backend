class CertificatesController < ActionController::Base
  include Authenticable

  before_action :authenticate_user
  before_action :set_variables

  def list
    certificates = @finder.event_only
    render json: certificates, status: :ok
  end

  def emit
    certificates = @finder.all
    attachments = generate_certificate_files certificates
    CertificateMailer.with(
      event: @event,
      user: @current_user,
      attachments: attachments
    ).certificate_email.deliver_now
  end

  def event; end
  def talk; end
  def staff; end

  private

  def set_variables
    @event = Event.find_by(slug: params[:event_slug])
    @finder = CertificateFinder.new(
      user: @current_user,
      event: @event,
      talk_id: params[:talk_id]
    )
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
end
