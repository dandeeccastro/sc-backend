class AddSpeakerIdToTalks < ActiveRecord::Migration[7.0]
  def change
    add_reference :talks, :speaker, null: true, foreign_key: true
  end
end
