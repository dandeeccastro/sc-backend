class CertificateFinder
  def initialize(criteria:,user: nil, event: nil)
    @user = user
    @event = event
    @criteria = criteria
  end

  def self.find_by(email: nil, slug: nil, talk_id: nil)
    if email && talk_id
      vacancies = Vacancy.joins(:talk, :user).where(presence: true, user: { email: email }, talk: { id: talk_id })
      speaker = Speaker.find_by(email: email)

      participation_certs = vacancies.map { |vacancy| talk_certificate_hash(user: vacancy.user, talk: vacancy.talk, event: vacancy.talk.event) }
      ministration_certs = speaker ? speaker.talks.map { |talk| speaker_certificate_hash(talk: talk, speaker: speaker, event: talk.event) } : nil

      [participation_certs, ministration_certs].flatten.compact
    elsif email && slug
      event = Event.find_by(slug: slug)
      vacancies = Vacancy.joins(:user, talk: [:event]).where(presence: true, user: { email: email }, talk: { events: { slug: slug }})
      speakers = Speaker.joins(talks:[:event]).where(email: email, talks: { events: { slug: slug }})
      staff = User.joins(teams: [:event]).where(email: email, teams: { events: { slug: slug }})

      participation_cert = [vacancies.empty? ? nil : attendee_certificate_hash(user: vacancies.first.user, event: vacancies.first.event)]
      staff_participation_cert = [staff_certificate_hash(event: event, user: staff.first)]
      participation_certs = vacancies.map { |vacancy| talk_certificate_hash(user: vacancy.user, talk: vacancy.talk, event: vacancy.talk.event) }
      ministration_certs = speakers.first&.talks&.map { |talk| speaker_certificate_hash(talk: talk, speaker: speakers.first, event: talk.event) }

      [participation_certs, participation_cert, staff_participation_cert, ministration_certs].flatten.compact
    elsif email
      vacancies = Vacancy.joins(:user, talk: [:event]).where(presence: true, user: { email: email })
      talks = Talk.joins(:speakers, :event).where(speakers: { email: email })
      staff = User.joins(teams: [:event]).where(email: email)

      participation_cert = vacancies.map { |vacancy| attendee_certificate_hash(user: vacancy.user, event: vacancy.event) }
      staff_participation_cert = staff.empty? ? [] : staff.first.teams.map { |team| staff_certificate_hash(event: team.event, user: staff.first) }
      participation_certs = vacancies.map { |vacancy| talk_certificate_hash(user: vacancy.user, talk: vacancy.talk, event: vacancy.talk.event) }
      ministration_certs = talks.map { |talk| speaker_certificate_hash(talk: talk, speaker: talk.speaker, event: talk.event) }

      [participation_certs, participation_cert, staff_participation_cert, ministration_certs].flatten.compact
    elsif talk_id
      vacancies = Vacancy.joins(:talk, :user).where(talk: { id: talk_id })
      talk = Talk.find(talk_id)

      participation_certs = vacancies.map { |vacancy| talk_certificate_hash(user: vacancy.user, talk: vacancy.talk, event: vacancy.talk.event) }
      ministration_certs = talk.nil? ? [] : talk.speakers.map { |speaker| speaker_certificate_hash(talk: talk, speaker: speaker, event: talk.event) }

      [participation_certs, ministration_certs].flatten.compact
    elsif slug
      event = Event.find_by(slug: slug)
      vacancies = Vacancy.joins(:user, talk: [:event]).where(presence: true, talk: { events: { slug: slug }})
      speakers = Speaker.joins(talks:[:event]).where(talks: { events: { slug: slug }})

      participation_cert = [vacancies.empty? ? nil : attendee_certificate_hash(user: vacancies.first.user, event: event)]
      staff_participation_cert = event.nil? ? [] : event.team.users.map {|user| staff_certificate_hash(event: event, user: user)} 
      participation_certs = vacancies.map { |vacancy| talk_certificate_hash(user: vacancy.user, talk: vacancy.talk, event: event) }
      ministration_certs = event.talks.map { |talk| talk.speakers.map {|speaker| speaker_certificate_hash(talk: talk, speaker: speaker, event: event) } }.flatten

      [participation_certs, participation_cert, staff_participation_cert, ministration_certs].flatten.compact
    else
      []
    end
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
    speaker.talks.map { |talk| speaker_certificate_hash(speaker: speaker, talk: talk, event: talk.event) } if speaker
    []
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

  def self.talk_certificate_hash(user:, event:, talk:)
    {
      title: "Certificado de Participação na Atividade #{talk.title} em #{event.name}",
      receiver: user.name,
      reason: talk.title,
      dre: user.dre,
      background_image: event.cert_background_wicked_url,
      email: user.email,
      type: :talk_participation,
      description: "Declaro por meio deste a participação de #{user.name}, portador do DRE #{user.dre}, na atividade #{talk.title} do evento #{event.name}, realizado na Universidade Federal do Rio de Janeiro entre os dias #{event.start_date.strftime('%d/%m/%y')} e #{event.end_date.strftime('%d/%m/%y')}",

      #hours: 4
    }
  end

  def self.attendee_certificate_hash(user:, event:)
    {
      title: "Certificado de Participação em #{event.name}",
      receiver: user.name,
      reason: event.name,
      dre: user.dre,
      email: user.email,
      type: :attendee_participation,
      background_image: event.cert_background_wicked_url,
      description: "Declaro por meio deste a participação de #{user.name}, portador do DRE #{user.dre}, no evento #{event.name}, realizado na Universidade Federal do Rio de Janeiro entre os dias #{event.start_date.strftime('%d/%m/%y')} e #{event.end_date.strftime('%d/%m/%y')}",
      # hours: 4
    }
  end

  def self.staff_certificate_hash(user:, event:)
    {
      title: "Certificado de Participação como Staff em #{event.name}",
      receiver: user.name,
      reason: event.name,
      dre: user.dre,
      email: user.email,
      type: :staff_participation,
      background_image: event.cert_background_wicked_url,
      description: "Declaro por meio deste a participação de #{user.name}, portador do DRE #{user.dre}, como membro de equipe organizadora do evento #{event.name}, realizado na Universidade Federal do Rio de Janeiro entre os dias #{event.start_date.strftime('%d/%m/%y')} e #{event.end_date.strftime('%d/%m/%y')}",
      # hours: 5
    }
  end

  def self.speaker_certificate_hash(talk:, speaker:, event:)
    {
      email: speaker.email,
      type: :speaker_participation,
      title: "Certificado de Participação como Palestrante na Atividade #{talk.title} em #{event.name}",
      receiver: speaker.name,
      reason: talk.title,
      background_image: event.cert_background_wicked_url,
      description: "Declaro por meio deste a participação de #{speaker.name} como palestrante da atividade \"#{talk.title}\" no evento #{event.name}, realizado na Universidade Federal do Rio de Janeiro entre os dias #{event.start_date.strftime('%d/%m/%y')} e #{event.end_date.strftime('%d/%m/%y')}",
    }
  end
end
