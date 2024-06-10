class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :dre, null: true
      t.integer :permissions, default: 1

      t.references :team, null: true, foreign_key: true
      t.references :talk, null: true, foreign_key: true

      t.timestamps
    end
  end
end
