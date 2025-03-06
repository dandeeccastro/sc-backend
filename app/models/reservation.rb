class Reservation < ApplicationRecord
  validate :under_stock_limit
  validate :under_merch_limit
  validates :amount, comparison: { greater_than: 0 }

  belongs_to :user
  belongs_to :merch

  serialize :options, JSON

  def under_stock_limit
    merch = Merch.find(merch_id)
    reservations = Reservation.where(merch_id: merch_id).sum('amount')
    errors.add(:over_stock_limit, 'Reservas estão lotadas para essa mercadoria!') if reservations >= merch.stock
  end

  def under_merch_limit
    merch = Merch.find(merch_id)
    previous_reservations_amount = Reservation.where(user_id: user.id, merch_id: merch_id).sum(:amount)
    full_amount = amount + previous_reservations_amount
    errors.add(:over_merch_limit, 'Suas reservas dessa mercadoria excedem o limite permitido!') if full_amount > merch.limit
  end
end
