class Event < ApplicationRecord
  validate :invalidates_talks

  before_save :set_defaults

  validates :name, uniqueness: true
  validates :slug, uniqueness: true

  has_many :merches, dependent: :destroy
  has_many :talks, dependent: :destroy
  has_one :team, dependent: :destroy

  has_one_attached :banner

  def invalidates_talks
    talks = Talk.where(event_id: id).where('start_date < :start_date OR end_date > :end_date', { start_date: start_date, end_date: end_date })
    errors.add(:invalidated_talks, "Existem #{talks.count} palestras que conflitam com o horário do evento") unless talks.empty?
  end

  def schedule
    TalkFormatter.format_talks_into_schedule(talks)
  end

  def banner_url
    banner.attached? ? Rails.application.routes.url_helpers.rails_blob_path(banner, only_path: true) : ''
  end

  private

  def set_defaults
    self.slug = name.parameterize if slug.blank?
    self.team = Team.create(event_id: id) if team_id.blank?
  end
end
