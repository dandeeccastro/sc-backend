class Speaker < ApplicationRecord
  has_one_attached :image
  belongs_to :event

  has_and_belongs_to_many :talks

  def image_url
    image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) : ''
  end
end
