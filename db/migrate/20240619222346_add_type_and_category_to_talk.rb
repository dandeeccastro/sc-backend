class AddTypeAndCategoryToTalk < ActiveRecord::Migration[7.0]
  def change
    add_reference :talks, :type, null: false, foreign_key: true
    add_reference :talks, :category, null: false, foreign_key: true
  end
end
