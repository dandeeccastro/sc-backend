class User < ApplicationRecord
  ATTENDEE = 1
  SPEAKER = 2
  STAFF = 4
  STAFF_LEADER = 8
  ADMIN = 16

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :dre, uniqueness: true
  validates :name, presence: true

  # Staff / Staff Leader
  has_and_belongs_to_many :teams

  # Attendee
  has_many :talks, through: :vacancies

  def admin?
    (permissions & ADMIN).positive?
  end

  def staff_leader?
    (permissions & STAFF_LEADER).positive?
  end

  def staff?
    (permissions & STAFF).positive?
  end

  def speaker?
    (permissions & SPEAKER).positive?
  end

  def attendee?
    (permissions & ATTENDEE).positive?
  end

  def runs_event?(event)
    event.team.users.find_by_id(id)
  end
end
