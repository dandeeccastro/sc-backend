class CreateTeamStaff < ActiveRecord::Migration[7.0]
  def change
    create_table :teams_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :team

      t.timestamps
    end
  end
end
