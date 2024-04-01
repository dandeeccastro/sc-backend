class Attendee < User
  has_many :vacancies, optional: true
end
