class Talk < ApplicationRecord
  belongs_to :event
  has_many :materials, optional: true
  has_many :vacancies
  has_many :speakers
  has_one :staff_member
end
