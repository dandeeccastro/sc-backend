class Attendee < ApplicationRecord
  belongs_to :user
  has_many :talks, through: :vacancies
end
