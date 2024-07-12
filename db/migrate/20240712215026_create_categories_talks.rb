class CreateCategoriesTalks < ActiveRecord::Migration[7.0]
  def change
    create_table :categories_talks do |t|
      t.references :category, null: false, foreign_key: true
      t.references :talk, null: false, foreign_key: true

      t.timestamps
    end
  end
end
