class CertificateFinder
  def initialize(user_id:, event_id:, talk_id: nil)
    @user = User.find(user_id) if user_id
    @event = Event.find(event_id) if event_id
    @talk = Talk.find(talk_id) if talk_id
  end

  def all
    [attendee_participation, staff_participation, ...participated_in_talks]
  end

  def staff_participation
    return unless @user.runs_event?(@event)

    staff_certificate_hash(user: @user, event: @event)
  end

  def attendee_participation
    has_participated = Vacancy.where('presence = true AND user_id = :user_id', { user_id: @user.id })
    return unless has_participated.empty?

    attendee_certificate_hash(user: @user, event: @event)
  end

  def participated_in_talks
    participations = Vacancy.where('presence = true AND user_id = :user_id', { user_id: @user.id })
    return unless participations.empty?

    participations.map { |vacancy| talk_certificate_hash(user: @user, event: @event, talk: vacancy.talk) }
  end

  def talk_certificate_hash(user:, event:, talk:)
    {
      name: "Certificado de Participação na Palestra #{talk.title} em #{event.name}",
      receiver: user.name,
      type: :talk_participation,
      hours: 4
    }
  end

  def attendee_certificate_hash(user:, event:)
    {
      name: "Certificado de Participação em #{event.name}",
      receiver: user.name,
      type: :attendee_participation,
      hours: 4
    }
  end

  def staff_certificate_hash(user:, event:)
    {
      name: "Certificado de Participação como Staff em #{event.name}",
      receiver: user.name,
      type: :staff_participation,
      hours: 5
    }
  end
end
