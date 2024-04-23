class Team < ApplicationRecord
  has_one :event
  has_and_belongs_to_many :staffs
end
