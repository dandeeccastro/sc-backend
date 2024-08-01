class Reservation < ApplicationRecord
  validate :under_stock_limit

  belongs_to :user
  belongs_to :merch

  serialize :options, JSON

  def under_stock_limit
    merch = Merch.find(merch_id)
    reservations = Reservation.where(merch_id: merch_id).sum('amount')
    errors.add(:over_limit, 'Reservas estão lotadas para essa mercadoria!') if reservations >= merch.stock
  end
end
