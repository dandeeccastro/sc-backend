class Reservation < ApplicationRecord
  validate :under_stock_limit

  belongs_to :user
  belongs_to :merch

  def under_stock_limit
    reservations = Reservation.where(merch_id: merch_id).count
    errors.add(:over_limit, 'Reservas estão lotadas para essa mercadoria!') if reservations >= merch.stock
  end
end
