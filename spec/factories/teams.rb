FactoryBot.define do
  factory :team do
    association :event
    users { [] }
  end
end
