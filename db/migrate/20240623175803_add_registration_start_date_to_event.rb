class AddRegistrationStartDateToEvent < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :registration_start_date, :datetime
  end
end
