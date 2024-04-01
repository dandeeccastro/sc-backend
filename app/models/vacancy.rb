class Vacancy < ApplicationRecord
  belongs_to :staff_member
  has_many :attendees
  has_many :talks
end
