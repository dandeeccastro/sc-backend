class CertificatesController < ActionController::Base
  include Authenticable
  include Loggable
  include Permissions

  before_action :authenticate_user, except: %i[debug]
  before_action :set_event
  before_action :set_permissions, only: %i[emit]
  before_action :set_variables, except: %i[debug]

  def list
    certificates = @finder.find
    render json: certificates, status: :ok
  end

  def emit
    EmitCertificatesJob.perform_now(email: params[:email], talk_id: params[:talk_id], slug: params[:event_slug])

    emission_type = generate_emission_message(params[:email], params[:talk_id], params[:event_slug])
    AuditLogger.log_message("#{@current_user.name} emitiu #{emission_type}")

    render json: { message: 'Certificados emitidos com sucesso!' }, status: :ok
  end

  # def emit
  #   certificates = @finder.find
  #   attachments = generate_certificate_files(certificates)
  #   case params[:emit_from]
  #   when 'event'
  #     emit_event(certificates)
  #   when 'user'
  #     CertificateMailer.with(
  #       event: @event,
  #       user: @user,
  #       attachments: attachments
  #     ).certificate_email.deliver_now
  #   when 'myself'
  #     CertificateMailer.with(
  #       event: @event,
  #       user: @current_user,
  #       attachments: attachments
  #     ).certificate_email.deliver_now
  #   end
  #   render json: { message: 'Certificados emitidos com sucesso!' }, status: :ok
  # end

  def debug
    @event = Event.find_by(slug: params[:slug])
    @current_user = User.find(1)
    user = @current_user
    event = @event
    locals = {
      event: @event,
      user: @current_user,
      email: @current_user.email,
      type: :talk_participation,
      title: "Certificado de Participação no evento #{@event.name}",
      receiver: @current_user.name,
      reason: @event.name,
      dre: @current_user.dre,
      background_image: "",
      description: "Declaro por meio deste a participação de #{user.name}, portador do DRE #{user.dre}, no evento #{event.name}, realizado na Universidade Federal do Rio de Janeiro entre os dias #{event.start_date.strftime("%d/%m/%Y")} e #{event.end_date.strftime("%d/%m/%Y")}",
      hours: 4
    }

    render :event, locals: locals
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

  def generate_emission_message(email, talk_id, event_slug)
    if email && talk_id
      user = User.find_by(email: email)
      talk = Talk.find(talk_id)
      emission_type = "certificados da atividade #{talk} para o usuário #{user}"
    elsif email && event_slug
      user = User.find_by(email: email)
      event = Event.find_by(slug: event_slug)
      emission_type = "certificados do evento #{event.title} para o usuário #{user}"
    elsif email
      user = User.find_by(email: email)
      emission_type = "certificados do usuário #{user}"
    elsif talk_id
      talk = Talk.find(talk_id)
      emission_type = "certificados da atividade #{user}"
    elsif slug
      event = Event.find_by(slug: event_slug)
      emission_type = "certificados do evento #{event}"
    else
      emission_type = 'certificados de forma incorreta'
    end

  end
end
