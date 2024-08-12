class CertificateFinder
  def initialize(criteria:,user: nil, event: nil)
    @user = user
    @event = event
    @criteria = criteria
  end

  def find
    return find_by_user if @criteria == 'myself'
    return find_by_event if @criteria == 'event'
    return find_by_user_and_event if @criteria == 'user'
  end

  def find_by_user
    user_attendee_participation
      .concat(user_staff_participation)
      .concat(user_talk_participation)
      .concat(user_speaker_participation)
      .compact
  end

  def find_by_event
    event_attendee_participation
      .concat(event_staff_participation)
      .concat(event_talk_participation)
      .concat(event_speaker_participation)
      .compact
  end

  def find_by_user_and_event
    event_and_user_attendee_participation
      .concat(event_and_user_staff_participation)
      .concat(event_and_user_talk_participation).compact
  end

  def user_attendee_participation
    events = Event.joins(talks: [ :vacancies ]).where(vacancies: { presence: true, user_id: @user.id }).distinct
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

  def user_speaker_participation
    speaker = Speaker.find_by(email: @user.email)
    speaker.talks.map { |talk| speaker_certificate_hash(speaker: speaker, talk: talk, event: talk.event) }
  end

  def event_attendee_participation
    users = User.joins(vacancies: [:talk]).where(vacancies: { presence: true }, talks: { event_id: @event.id })
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

  def event_speaker_participation
    talks = Talk.where(event: @event)
    talks.inject([]) do |acc, talk|
      acc.concat(talk.speakers.map{|speaker| speaker_certificate_hash(speaker: speaker, talk: talk, event: talk.event)})
    end
    # talks.inject([]) { |acc, talk| talk.speakers.map { |speaker| speaker_certificate_hash(speaker: speaker, talk: talk, event: talk.event) } }
  end

  def event_and_user_attendee_participation
    talk_ids = @event.talks.map(&:id)
    participation = Vacancy.where(presence: true, talk_id: talk_ids, user_id: @user.id).exists?
    [ attendee_certificate_hash(user: @user, event: @event) ] if participation
    []
  end

  def event_and_user_staff_participation
    [ staff_certificate_hash(user: @user, event: @event) ] if @user.runs_event?(@event)
    []
  end

  def event_and_user_talk_participation
    talk_ids = @event.talks.map(&:id)
    talks = Talk.joins(:vacancies).where(vacancies: { presence: true, user_id: @user.id, talk_id: talk_ids })
    talks.map{ |talk| talk_certificate_hash(user: @user, event: @event, talk: talk) }
  end

  def talk_certificate_hash(user:, event:, talk:)
    {
      event: event,
      user: user,
      email: user.email,
      type: :talk_participation,
      title: "Certificado de Participação na Atividade #{talk.title} em #{event.name}",
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

  def speaker_certificate_hash(talk:, speaker:, event:)
    {
      talk: talk,
      user: speaker,
      event: event,
      email: speaker.email,
      type: :speaker_participation,
      title: "Certificado de Participação como Palestrante na Atividate #{talk.title} em #{event.name}",
      receiver: speaker.name,
      reason: talk.title,
    }
  end
end
