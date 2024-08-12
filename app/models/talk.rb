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

  before_save do
    self.start_date = start_date.change(sec: 0, usec: 0)
    self.end_date = end_date.change(sec: 0, usec: 0)
  end

  def overlaps_with_other_talk
    overlapping_talks = Talk
      .where.not(id: id)
      .where(location_id: location_id)
      .where(
        '(:start_date <= start_date AND start_date < :end_date) OR (:start_date < end_date AND end_date <= :end_date) OR (start_date <= :start_date AND :end_date <= end_date)',
        {start_date: start_date, end_date: end_date})
    
    errors.add(:overlap, "Horário de #{start_date} até #{end_date} sobrepõe com as seguintes atividades: #{overlapping_talks.join(', ')}") unless overlapping_talks.empty?
  end

  def outside_event_bounds
    not_in_event = event.start_date > start_date || event.end_date < end_date
    errors.add(:out_of_bounds, 'Horário não está dentro do evento!') if not_in_event
  end

  def to_s
    "#{title}: De #{start_date} até #{end_date}"
  end
end
