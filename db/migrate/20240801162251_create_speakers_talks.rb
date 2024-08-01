class CreateSpeakersTalks < ActiveRecord::Migration[7.0]
  def change
    create_table :speakers_talks do |t|
      t.references :speaker, null: false, foreign_key: true
      t.references :talk, null: false, foreign_key: true

      t.timestamps
    end
  end
end
