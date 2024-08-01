class Talk < ApplicationRecord
  self.inheritance_column = 'other'

  validate :overlaps_with_other_talk
  validate :outside_event_bounds

  belongs_to :event
  belongs_to :location
  belongs_to :type

  has_many :materials
  has_many :vacancies, dependent: :destroy
  has_many :users, through: :vacancies
  has_many :ratings
  has_many :notifications, dependent: :destroy

  has_and_belongs_to_many :speakers
  has_and_belongs_to_many :categories

  def rating
    return 0 if ratings.empty?

    ratings.map(&:score).reduce(:+) / ratings.length
  end

  def participants
    vacancies.count
  end

  def day
    start_date.strftime('%d/%m/%y')
  end

  def overlaps_with_other_talk
    overlapping_talks = Talk.where(
      'id != :id AND location_id = :location_id AND event_id = :event_id AND ((start_date >= :start_date AND end_date <= :start_date) OR (start_date >= :end_date AND end_date <= :end_date))',
      { start_date: start_date, end_date: end_date, location_id: location_id, event_id: event_id, id: id }
    )
    errors.add(:overlap, 'Horário sobrepõe com outra palestra!') unless overlapping_talks.empty?
  end

  def outside_event_bounds
    not_in_event = event.start_date > start_date || event.end_date < end_date
    errors.add(:out_of_bounds, 'Horário não está dentro do evento!') if not_in_event
  end
end
