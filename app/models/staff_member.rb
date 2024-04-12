class StaffMember < ApplicationRecord
  belongs_to :user
  has_many :teams
  has_many :vacancies, optional: true # Attendee
end
