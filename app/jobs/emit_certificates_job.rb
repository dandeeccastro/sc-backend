class EmitCertificatesJob < ApplicationJob
  queue_as :default
  self.queue_adapter = :sidekiq

  def perform(email:,talk_id:,slug:)
    certificate_data = CertificateFinder.find_by(
      email: email,
      talk_id: talk_id,
      slug: slug
    )
    cert_map = generate_certificate_map(certificate_data)
    # email_to_attachments = cert_map.each { |key, val| cert_map[key] = create_attachments(val) }
    cert_map.each { |email, attachments| CertificateMailer.with(
      email: email,
      attachments: attachments.map{ |a| a[:file] },
      subject: attachments.first[:subject],
      receiver: attachments.first[:receiver],
      reason: attachments.first[:reason]
    ).certificate_email.deliver_now}
  end

  def create_pdf_data(cert)
    {
      filename: "#{cert[:title]}.pdf",
      data: create_pdf_file(cert)
    }
  end

  def generate_certificate_map(cert_data)
    cert_data.reduce({}) do |acc, cert|
      cert[:file] = create_pdf_data(cert)
      if acc[cert[:email]]
        acc[cert[:email]] << cert
      else
        acc[cert[:email]] = [cert]
      end
      acc
    end
  end

  def create_pdf_file(cert_data)
    ac = ActionController::Base.new
    pdf_data = ac.render_to_string 'certificates/event', locals: cert_data
    # case cert_data[:type]
    # when :talk_participation
    #   pdf_data = ac.render_to_string 'certificates/talk', locals: cert_data
    # when :attendee_participation
    #   pdf_data = ac.render_to_string 'certificates/event', locals: cert_data
    # when :staff_participation
    #   pdf_data = ac.render_to_string 'certificates/staff', locals: cert_data
    # when :speaker_participation
    #   pdf_data = ac.render_to_string 'certificates/speaker', locals: cert_data
    # end
    puts pdf_data
    WickedPdf.new.pdf_from_string(pdf_data, pdf_options)
  end

  def create_attachments(certs)
    idx = 1
    certs.reduce({}) do |acc, cert|
      acc["Certificado #{idx}"] = create_pdf_file(cert)
      idx += 1
    end
  end

  def pdf_options
    {
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
    }
  end
end
