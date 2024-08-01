class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :event, optional: true
  belongs_to :talk, optional: true
end
