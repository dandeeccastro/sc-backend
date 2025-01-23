class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :event, optional: true
  belongs_to :talk, optional: true

  validates :title, presence: true
  validates :description, presence: true
end
