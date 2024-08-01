class Team < ApplicationRecord
  belongs_to :event, optional: true
  has_and_belongs_to_many :users

  before_save do
    user_ids.each do |user_id|
      user = User.find(user_id)
      user.update(permissions: user.permissions | User::STAFF)
    end
  end
end
