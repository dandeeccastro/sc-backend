FactoryBot.define do
  factory :vacancy do
    user
    talk { nil }
  end

  factory :location do
    name { 'Roxinho CCMN' }
  end

  factory :event do
    name { 'Semana da Computação 2024' }
    talks { [] }
  end

  factory :user do
    name { 'Lorem Ipsum' }
    sequence(:email) { |n| "regularuser#{n}@gmail.com" }
    sequence(:dre) { |n| "1111111111#{n}" }
    password { 'senha123' }
  end

  factory :attendee, class: 'User' do
    name { 'Lorem Ipsum' }
    sequence(:email) { |n| "attendee#{n}@gmail.com" }
    sequence(:dre) { |n| "2111111111#{n}" }
    password { 'senha123' }
    permissions { User::ATTENDEE }
  end

  factory :speaker, class: 'User' do
    name { 'Lorem Ipsum' }
    sequence(:email) { |n| "speaker#{n}@gmail.com" }
    sequence(:dre) { |n| "311111111#{n}1" }
    password { 'senha123' }
    permissions { User::SPEAKER }
  end

  factory :staff, class: 'User' do
    name { 'Lorem Ipsum' }
    sequence(:email) { |n| "staff#{n}@gmail.com" }
    sequence(:dre) { |n| "41111111#{n}11" }
    password { 'senha123' }
    permissions { User::STAFF }
  end

  factory :staff_leader, class: 'User' do
    name { 'Lorem Ipsum' }
    sequence(:email) { |n| "staffleader#{n}@gmail.com" }
    sequence(:dre) { |n| "5111111#{n}111" }
    password { 'senha123' }
    permissions { User::STAFF_LEADER }
  end

  factory :admin, class: 'User' do
    name { 'Lorem Ipsum' }
    sequence(:email) { |n| "admin#{n}@gmail.com" }
    sequence(:dre) { |n| "611111#{n}1111" }
    password { 'senha123' }
    permissions { User::ADMIN }
  end

  factory :talk do
    title { 'Example Talk' }
    description { 'This is an example talk for testing purposes' }
    start_date { '2024-04-16 00:00' }
    end_date { '2024-04-16 00:00' }
    event { nil }
    vacancy_limit { 40 }
    location
  end

  factory :team do
    users { [] }
    event { nil }
  end

  factory :merch do
    name { 'Example Merch' }
    price { 9999 }
    event
  end

  factory :material do
    name { |n| "Material #{n}" }
  end
end
