class CreateSpeakers < ActiveRecord::Migration[7.0]
  def change
    create_table :speakers do |t|
      t.string :name, null: false
      t.text :bio

      t.timestamps
    end
  end
end
