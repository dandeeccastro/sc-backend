class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :name
      t.references :talk, null: false, foreign_key: true

      t.timestamps
    end
  end
end
