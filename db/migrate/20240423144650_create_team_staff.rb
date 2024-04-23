class CreateTeamStaff < ActiveRecord::Migration[7.0]
  def change
    create_table :staffs_teams, id: false do |t|
      t.belongs_to :staff
      t.belongs_to :team

      t.timestamps
    end
  end
end
