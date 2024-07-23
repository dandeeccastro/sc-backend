FactoryBot.define do
  factory :vacancy do
    presence { false }
    factory :confirmed_presence do
      presence { true }
    end
  end
end
