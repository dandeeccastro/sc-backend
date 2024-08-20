class EmitCertificatesJob < ApplicationJob
  queue_as :default

  def perform(*params)
    # Pegando os parâmetros
    set_variables
    # Pegando os certificados pelo Finder
    certificate_data = @finder.find
    attachments = generate_certificate_files(certificate_data)
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
  end

  def generate_certificate_files(certificate_data)
    idx = 0
    attachments = {}
    certificate_data.each do |cert|
      case cert[:type]
      when :talk_participation
        pdf_data = render_to_string CertificateController.talk, locals: cert
      when :attendee_participation
        pdf_data = render_to_string :event, locals: cert
      when :staff_participation
        pdf_data = render_to_string :staff, locals: cert
      when :speaker_participation
        pdf_data = render_to_string :speaker, locals: cert
      end
      attachments["Certificado #{idx}.pdf"] = WickedPdf.new.pdf_from_string(pdf_data, {
        orientation: 'Landscape',
        page_size: 'A4',
        margin: {
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
        },
        # page_width: 1920,
        # page_height: 1080,
        background: true
      })
      idx += 1
    end
    attachments
  end

  def set_variables
    @event = Event.find_by(slug: params[:event_slug])
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
    end
  end
end
