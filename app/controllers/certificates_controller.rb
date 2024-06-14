class CertificatesController < ActionController::Base
  def list
    finder = CertificateFinder.new(user_id: params[:user_id], event_id: params[:event_id])
    certificates = finder.all
    render json: certificates, status: :ok
  end

  def emit
    finder = CertificateFinder.new(user_id: params[:user_id], event_id: params[:event_id])
    certificates = finder.all
    attachments = generate_certificate_files certificates
    CertificateMailer.with(
      event: Event.find(params[:event_id]),
      user: User.find(params[:user_id]),
      attachments: attachments
    ).certificate_email.deliver_now
  end

  def event; end
  def talk; end
  def staff; end

  private

  def set_variables_from_params
    @event = Event.find(params[:event_id])
    @user = User.find(params[:user_id])
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
