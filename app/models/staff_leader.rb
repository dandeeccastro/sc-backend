class StaffLeader < User
  has_many :teams
  has_many :vacancies, optional: true
end
