class Vacancy < ApplicationRecord
  belongs_to :attendee
  belongs_to :talk
end
