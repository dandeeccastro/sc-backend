class Team < ApplicationRecord
  belongs_to :event, optional: true
  has_and_belongs_to_many :users

  before_save do
    users = User.find(user_ids)
    users.each do |user|
      user.update(permissions: user.permissions | User::STAFF) if user.permissions & 0b11100 == 0
    end
    self.user_ids = user_ids
  end
end
