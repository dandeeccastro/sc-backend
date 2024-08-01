class RemoveSizeFromReservation < ActiveRecord::Migration[7.0]
  def change
    remove_column :reservations, :size, :string
  end
end
