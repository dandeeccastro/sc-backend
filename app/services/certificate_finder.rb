class CertificateFinder
  def initialize(user:, event: nil, talk_id: nil)
    @user = user
    @event = event
    @talk_id = talk_id
  end

  def all
    attendee_participation.concat(staff_participation).concat(talk_participation).compact
  end

  def attendee_participation
    if @event
      vacancies = Vacancy.joins(:talk).where(presence: true, user_id: @user.id, talk: { event_id: @event.id }).exists?
      return vacancies ? [attendee_certificate_hash(user: @user, event: @event)] : []
    end

    events = Event.joins(talks: [ :vacancies ]).where(vacancies: { presence: true, user_id: @user.id })
    events.map { |event| attendee_certificate_hash(user: @user, event: event) }
  end

  def staff_participation
    return @user.runs_event?(@event) ? [staff_participation_hash(user: @user, event: @event)] : [] if @event

    events = Event.all
    events.reduce([]) { |mem, event| mem << staff_participation_hash(user: @user, event: event) if @user.runs_event?(event) }
  end

  def talk_participation
    vacancies = Vacancy.where(presence: true, user_id: @user.id)
    return vacancies.reduce([]) { |mem, var| mem << talk_certificate_hash(user: @user, talk: vacancy.talk, event: @event) if vacancy.talk.event == @event } if @event

    vacancies.map { |vacancy| talk_certificate_hash(user: @user, talk: vacancy.talk, event: vacancy.talk.event) }
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
