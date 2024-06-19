class AddTypesAndCategoriesToTalks < ActiveRecord::Migration[7.0]
  def change
    add_column :talks, :type, :string
    add_column :talks, :category, :string
  end
end
