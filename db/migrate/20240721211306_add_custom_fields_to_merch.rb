class AddCustomFieldsToMerch < ActiveRecord::Migration[7.0]
  def change
    add_column :merches, :custom_fields, :text
  end
end
