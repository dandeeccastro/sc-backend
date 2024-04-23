class Event < ApplicationRecord
  has_many :merches
  has_many :talks
  belongs_to :team, optional: true
end
