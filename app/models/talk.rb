class Talk < ApplicationRecord
  validate :overlaps_with_other_talk

  belongs_to :event
  belongs_to :location
  has_many :materials
  has_many :vacancies
  has_many :speakers
  has_one :staff

  def overlaps_with_other_talk
    overlapping_talks = Talk.where(
      'location_id = :location AND event_id = :event AND id != :id AND ((start_date >= :start_date AND end_date <= :start_date) OR (start_date >= :end_date AND end_date <= :end_date))',
      { start_date: start_date, end_date: end_date, location: location_id, id: id, event: event_id }
    )
    errors.add(:overlap, 'Horário sobrepõe com outra palestra!') unless overlapping_talks.empty?
  end
end
