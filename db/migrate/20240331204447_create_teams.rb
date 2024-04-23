class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
