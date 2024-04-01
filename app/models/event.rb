class Event < ApplicationRecord
  has_many :merches
  has_many :talks
  has_one :team
end
