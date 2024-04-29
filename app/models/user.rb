class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :dre, uniqueness: true
  validates :name, presence: true

  has_one :admin, dependent: :destroy
  has_one :staff, dependent: :destroy
  has_one :speaker, dependent: :destroy
  has_one :attendee, dependent: :destroy
end
