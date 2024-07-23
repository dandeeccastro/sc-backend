class Category < ApplicationRecord
  has_and_belongs_to_many :talks
  belongs_to :event
end
