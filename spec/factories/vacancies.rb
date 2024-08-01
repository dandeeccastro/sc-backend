FactoryBot.define do
  factory :vacancy do
    presence { false }

    factory :confirmed_presence do
      presence { true }
    end

    factory :vacancy_with_user do
      association :user, factory: :attendee
    end
  end
end
