class AddSizeAndAmountToReservation < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :size, :string
    add_column :reservations, :amount, :integer
  end
end
