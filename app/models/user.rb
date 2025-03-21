class User < ApplicationRecord
  ATTENDEE = 1
  SPEAKER = 2
  STAFF = 4
  STAFF_LEADER = 8
  ADMIN = 16

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :dre, uniqueness: true, allow_nil: true
  validates :name, presence: true
  validates :cpf, uniqueness: true, presence: true

  validate :cpf_valid?

  # Staff / Staff Leader
  has_and_belongs_to_many :teams

  # Attendee
  has_many :talks, through: :vacancies
  has_many :vacancies

  has_many :merches, through: :reservations
  has_many :ratings

  before_save do
    self.cpf = cpf.gsub(/[\D]/,'')
  end

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
    return false if event.nil?
    event.team.users.find_by_id(id).present?
  end

  def cpf_valid?
    errors.add(:invalid_cpf, 'CPF inválido') unless CPF.valid?(cpf)
  end

  def to_s
    "#{role} #{name} (email: #{email})"
  end

  private

  def role
    return "ADMIN" if admin?
    return "LÍDER DE EQUIPE" if staff_leader?
    return "STAFF" if staff?
    return "PALESTRANTE" if speaker?
    "PARTICIPANTE"
  end
end
