class AddOcupationAndInstitutionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :ocupation, :string
    add_column :users, :institution, :string
  end
end
