class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :dre, uniqueness: true
  validates :name, presence: true

  has_one :admin
  has_one :staff
  has_one :speaker
  has_one :attendee
end
