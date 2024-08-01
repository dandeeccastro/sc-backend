class AddEventToSpeaker < ActiveRecord::Migration[7.0]
  def change
    add_reference :speakers, :event, null: true, foreign_key: true
  end
end
