class AddReservationLimitToMerch < ActiveRecord::Migration[7.0]
  def change
    add_column :merches, :limit, :integer
  end
end
