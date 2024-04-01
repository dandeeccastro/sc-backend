class Team < ApplicationRecord
  belongs_to :event
  has_many :staff_members
  has_many :staff_leaders
end
