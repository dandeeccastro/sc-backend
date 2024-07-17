class AddDeliveredToReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :delivered, :boolean, default: false
  end
end
