class Event < ApplicationRecord
  validates :name, uniqueness: true

  has_many :merches
  has_many :talks
  belongs_to :team, optional: true
end
