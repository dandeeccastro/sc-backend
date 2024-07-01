class Reservation < ApplicationRecord
  validates_uniqueness_of :merch_id, scope: [:user_id]

  belongs_to :user
  belongs_to :merch
end
