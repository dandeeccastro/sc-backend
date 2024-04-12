class StaffLeader < ApplicationRecord
  belongs_to :user
  has_many :teams
  has_many :vacancies
end
