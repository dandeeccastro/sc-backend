class RemoveTypeAndCategoryFromTalk < ActiveRecord::Migration[7.0]
  def change
    remove_column :talks, :type, :string
    remove_column :talks, :category, :string
  end
end
