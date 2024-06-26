class CertificatesController < ActionController::Base
  include Authenticable

  before_action :authenticate_user
  before_action :set_finder

  def list
    certificates = @finder.all
    render json: certificates, status: :ok
  end

  def index
    certificate = @finder.by_type(params[:type])
    render json: certificate, status: :ok
  end

  def emit
    certificates = @finder.all
    attachments = generate_certificate_files certificates
    CertificateMailer.with(
      event: Event.find(params[:event_id]),
      user: User.find(@current_user.id),
      attachments: attachments
    ).certificate_email.deliver_now
  end

  def event; end
  def talk; end
  def staff; end

  private

  def set_finder
    @finder = CertificateFinder.new(
      user_id: @current_user.id,
      event_slug: params[:event_slug],
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
