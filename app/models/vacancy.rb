class Vacancy < ApplicationRecord
  belongs_to :staff
  has_many :attendees
  has_many :talks
end
