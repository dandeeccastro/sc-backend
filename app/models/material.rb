class Material < ApplicationRecord
  belongs_to :talk
  has_one_attached :file
end
