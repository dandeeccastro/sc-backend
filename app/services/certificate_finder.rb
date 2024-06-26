class CertificateFinder
  def initialize(user_id:, event_slug:, talk_id: nil)
    @user = User.find(user_id) if user_id
    @event = Event.find_by(slug: event_slug) if event_slug
    @talk = Talk.find(talk_id) if talk_id
  end

  def all
    [attendee_participation, staff_participation].concat(participated_in_talks).compact
  end

  def by_type(type)
    case type.to_sym
    when :talk_participation
      participated_in_talk
    when :attendee_participation
      attendee_participation
    when :staff_participation
      staff_participation
    end
  end

  def staff_participation
    return unless @user.runs_event?(@event)

    staff_certificate_hash(user: @user, event: @event)
  end

  def attendee_participation
    has_participated = Vacancy.where('presence = true AND user_id = :user_id', { user_id: @user.id })
    return if has_participated.empty?

    attendee_certificate_hash(user: @user, event: @event)
  end

  def participated_in_talks
    participations = Vacancy.where('presence = true AND user_id = :user_id', { user_id: @user.id })
    return [] if participations.empty?

    participations.map { |vacancy| talk_certificate_hash(user: @user, event: @event, talk: vacancy.talk) }
  end

  def participated_in_talk
    participations = Vacancy.where(presence: true, user_id: @user.id, talk_id: @talk.id)
    return [] if participations.empty?
    
    talk_certificate_hash(user: @user, event: @event, talk: @talk)
  end

  def talk_certificate_hash(user:, event:, talk:)
    {
      type: :talk_participation,
      title: "Certificado de Participação na Palestra #{talk.title} em #{event.name}",
      receiver: user.name,
      reason: talk.title,
      dre: user.dre,
      hours: 4
    }
  end

  def attendee_certificate_hash(user:, event:)
    {
      type: :attendee_participation,
      title: "Certificado de Participação em #{event.name}",
      receiver: user.name,
      reason: event.name,
      dre: user.dre,
      hours: 4
    }
  end

  def staff_certificate_hash(user:, event:)
    {
      type: :staff_participation,
      title: "Certificado de Participação como Staff em #{event.name}",
      receiver: user.name,
      reason: event.name,
      dre: user.dre,
      hours: 5
    }
  end
end
