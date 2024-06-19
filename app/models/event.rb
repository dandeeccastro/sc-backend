class Event < ApplicationRecord
  validate :invalidates_talks

  before_save :set_slug

  validates :name, uniqueness: true
  validates :slug, uniqueness: true

  has_many :merches
  has_many :talks
  has_one :team

  def invalidates_talks
    talks = Talk.where('start_date < :start_date OR end_date > :end_date AND event_id = :event_id', { start_date: start_date, end_date: end_date, event_id: id })
    errors.add(:invalidated_talks, "Existem #{talks.count} palestras que conflitam com o horário do evento") unless talks.empty?
  end

  def schedule
    dates = Hash[talks.map(&:day).uniq.collect{ |v| [v, []] }]
    talks.each { |talk| dates[talk.day] << talk }
    dates.map { |date, talks| dates[date] = TalkBlueprint.render(talks, view: :simple) }
    dates
  end

  private

  def set_slug
    self.slug = name.parameterize if slug.blank?
  end
end
