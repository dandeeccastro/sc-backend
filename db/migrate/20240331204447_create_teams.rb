class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.references :event, null: true, foreign_key: true

      t.timestamps
    end
  end
end
