class Staff < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :teams

  def from_event?(event)
    return event.team.staffs.find(id) if event.present?

    false
  end
end
