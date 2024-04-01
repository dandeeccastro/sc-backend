class Admin < User
  has_many :events, optional: true
end
