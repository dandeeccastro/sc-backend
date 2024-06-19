class Speaker < ApplicationRecord
  has_one_attached :image
  has_many :talks
end
