class Event < ApplicationRecord
  validate :invalidates_talks

  before_save :set_slug

  validates :name, uniqueness: true
  validates :slug, uniqueness: true

  has_many :merches
  has_many :talks
  has_one :team

  def invalidates_talks
    talks = Talk.where(event_id: id).where('start_date < :start_date OR end_date > :end_date', { start_date: start_date, end_date: end_date })
    errors.add(:invalidated_talks, "Existem #{talks.count} palestras que conflitam com o horário do evento") unless talks.empty?
  end

  def schedule
    TalkFormatter.format_talks_into_schedule(talks)
  end

  private

  def set_slug
    self.slug = name.parameterize if slug.blank?
  end
end
