FactoryBot.define do
  factory :attendee do
    user { nil }
  end

  factory :staff_leader do
    user { nil }
  end

  factory :staff_member do
    user { nil }
  end

  factory :speaker do
    user { nil }
  end

  factory :admin do
    user { nil }
  end

  factory :event do
    name { 'Semana da Computação 2024' }
  end

  factory :user do
    name { 'Lorem Ipsum' }
    email { 'lorem.ipsum@gmail.com' }
    password { 'senha123' }
    dre { '12312312312' }
  end
end
