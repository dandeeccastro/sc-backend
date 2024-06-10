class Notification < ApplicationRecord
  belongs_to :event
  belongs_to :user
  belongs_to :talk, optional: true
end
