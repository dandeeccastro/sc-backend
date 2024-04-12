class CreateStaffLeaders < ActiveRecord::Migration[7.0]
  def change
    create_table :staff_leaders do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
