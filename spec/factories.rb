FactoryBot.define do
  factory :location do
    name { 'Roxinho CCMN' }
  end

  factory :staff do
    leader { false }
    user
  end

  factory :staff_leader, class: 'Staff' do
    leader { true }
    user
  end

  factory :attendee do
    user
  end

  factory :speaker do
    user
  end

  factory :admin do
    user
  end

  factory :event do
    name { 'Semana da Computação 2024' }
    talks { [] }
  end

  factory :user do
    name { 'Lorem Ipsum' }
    sequence(:email) { |n| "lorem.ipsum#{n}@gmail.com" }
    sequence(:dre) { |n| "1111111111#{n}" }
    password { 'senha123' }
  end

  factory :talk do
    title { 'Example Talk' }
    description { 'This is an example talk for testing purposes' }
    start_date { '2024-04-16 00:00' }
    end_date { '2024-04-16 00:00' }
    event { nil }
    location { nil }
  end

  factory :team do
    staffs { [] }
    event { nil }
  end

  factory :merch do
    name { 'Example Merch' }
    price { 9999 }
    event
  end
end
