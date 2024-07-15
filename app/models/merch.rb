class Merch < ApplicationRecord
  belongs_to :event
  has_one_attached :image
  has_many :users, through: :reservations
  has_many :reservations, dependent: :destroy

  def image_url
    image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) : ''
  end
end
