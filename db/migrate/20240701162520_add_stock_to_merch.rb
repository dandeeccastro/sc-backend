class AddStockToMerch < ActiveRecord::Migration[7.0]
  def change
    add_column :merches, :stock, :integer
  end
end
