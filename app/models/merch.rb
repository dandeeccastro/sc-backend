class Merch < ApplicationRecord
  belongs_to :event
  has_one_attached :image
  has_many :users, through: :reservations
end
