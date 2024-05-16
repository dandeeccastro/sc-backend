class Reservation < ApplicationRecord
  validate :unique_per_user

  belongs_to :user
  belongs_to :merch

  def unique_per_user
    conflicting_reservations = Reservation.where('user_id = :user_id AND merch_id = :merch_id AND id != :id',
                                                 { user_id: user.id, merch_id: merch.id, id: id })
    errors.add(:already_reserved, 'You already have a reservation for this merch!') unless conflicting_reservations.empty?
  end
end
