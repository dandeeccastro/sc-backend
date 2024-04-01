class CreateMerches < ActiveRecord::Migration[7.0]
  def change
    create_table :merches do |t|
      t.string :name
      t.integer :price
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
