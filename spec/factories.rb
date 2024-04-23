FactoryBot.define do
  factory :staff do
    leader { false }
    user { nil }
  end

  factory :staff_leader, class: 'Staff' do
    leader { true }
    user { nil }
  end

  factory :attendee do
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
    talks { [] }
  end

  factory :user do
    name { 'Lorem Ipsum' }
    email { 'lorem.ipsum@gmail.com' }
    password { 'senha123' }
    dre { '12312312312' }
  end

  factory :talk do
    title { 'Example Talk' }
    description { 'This is an example talk for testing purposes' }
    start_date { '2024-04-16 00:00' }
    end_date { '2024-04-16 00:00' }
    event { nil }
  end

  factory :team do
    staffs { [] }
    event { nil }
  end
end
