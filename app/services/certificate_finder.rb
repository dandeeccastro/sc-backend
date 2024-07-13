class CertificateFinder
  def initialize(criteria:,user: nil, event: nil)
    @user = user
    @event = event
    @criteria = criteria
  end

  def find
    return find_by_user if @criteria == 'user'
    return find_by_event if @criteria == 'event'

    []
  end

  def find_by_user
    user_attendee_participation.concat(user_staff_participation).concat.(user_talk_participation).compact
  end

  def find_by_event
    event_attendee_participation.concat(event_staff_participation).concat.(event_talk_participation).compact
  end

  def user_attendee_participation
    events = Events.join(talks: [ :vacancies ]).where(vacancies: { presence: true, user_id: @user.id }).distinct
    events.map { |event| attendee_certificate_hash(user: @user, event: event) }
  end

  def user_staff_participation
    events = Event.joins(team: [ :users ]).where(users: { id: @user.id })
    events.map { |event| staff_certificate_hash(user: @user, event: event) }
  end

  def user_talk_participation
    talks = Talk.joins(:vacancies).where(vacancies: { presence: true, user_id: @user.id})
    talks.map { |talk| talk_certificate_hash(user: @user, talk: talk, event: talk.event) }
  end

  def event_attendee_participation
    users = User.joins(vacancies: [:talks]).where(vacancies: { presence: true }, talks: { event_id: @event.id })
    users.map { |user| attendee_certificate_hash(user: user, event: @event)}
  end

  def event_staff_participation
    users = @event.team.users
    users.map { |user| staff_certificate_hash(user: user, event: @event)}
  end

  def event_talk_participation
    talk_ids = @event.talks.map(&:id)
    vacancies = Vacancy.where(presence: true, talk_id: talk_ids)
    vacancies.map { |vacancy| talk_certificate_hash(user: vacancy.user, talk: vacancy.talk, event: @event) }
  end

  def talk_certificate_hash(user:, event:, talk:)
    {
      event: event,
      user: user,
      email: user.email,
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
      event: event,
      user: user,
      email: user.email,
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
      event: event,
      user: user,
      email: user.email,
      type: :staff_participation,
      title: "Certificado de Participação como Staff em #{event.name}",
      receiver: user.name,
      reason: event.name,
      dre: user.dre,
      hours: 5
    }
  end
end
