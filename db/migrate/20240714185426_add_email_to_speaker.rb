class AddEmailToSpeaker < ActiveRecord::Migration[7.0]
  def change
    add_column :speakers, :email, :string
  end
end
