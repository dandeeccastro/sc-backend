class CreateTalks < ActiveRecord::Migration[7.0]
  def change
    create_table :talks do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.belongs_to :event, foreign_key: true
      t.belongs_to :location, foreign_key: true

      t.timestamps
    end
  end
end
