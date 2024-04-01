class CreateVacancies < ActiveRecord::Migration[7.0]
  def change
    create_table :vacancies do |t|
      t.boolean :presence
      t.references :staff_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
