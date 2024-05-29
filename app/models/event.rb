class Event < ApplicationRecord
  before_save :set_slug

  validates :name, uniqueness: true
  validates :slug, uniqueness: true

  has_many :merches
  has_many :talks
  belongs_to :team, optional: true

  private

  def set_slug
    self.slug = name.parameterize if slug.blank?
  end
end
