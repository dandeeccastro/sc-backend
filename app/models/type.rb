class Type < ApplicationRecord
  validates :name, presence: :true
  validates :color, presence: :true
end
