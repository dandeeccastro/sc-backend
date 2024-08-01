class Speaker < ApplicationRecord
  has_one_attached :image
  has_many :talks
  belongs_to :event

  def image_url
    image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) : ''
  end
end
