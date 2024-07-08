class Merch < ApplicationRecord
  belongs_to :event
  has_one_attached :image
  has_many :users, through: :reservations
  has_many :reservations, dependent: :destroy
end
