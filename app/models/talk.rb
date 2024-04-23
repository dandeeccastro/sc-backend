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
      'start_date >= :start_date AND end_date <= :end_date AND location_id = :location AND id != :id',
      { start_date: start_date, end_date: end_date, location: location_id, id: id }
    )
    errors.add(:overlap, 'Horário sobrepõe com outra palestra!') unless overlapping_talks.empty?
  end
end
