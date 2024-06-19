FactoryBot.define do
  factory :speaker do
    name { "MyString" }
    bio { "MyText" }
    image { nil }
  end

  factory :rating do
    score { 1 }
    user { nil }
    talk { nil }
  end

  factory :notification do
    description { 'Teste notification' }
    event { nil }
    user { nil }
  end

  factory :reservation do
    user
    merch
  end

  factory :vacancy do
    user
    talk { nil }
  end

  factory :location do
    name { 'Roxinho CCMN' }
  end

  factory :event do
    sequence(:name) { |n| "Semana da Computação 202#{n}" }
    start_date { '03/06/2024 12:00' }
    end_date { '03/08/2024 12:00' }
    talks { [] }
  end

  factory :user do
    sequence(:name) { |n| "Lorem Ipsum #{n}" }
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
    start_date { '16/06/2024 00:00' }
    end_date { '16/06/2024 01:00' }
    event { nil }
    vacancy_limit { 40 }
    location
    speaker
  end

  factory :team do
    users { [] }
    event { nil }
  end

  factory :merch do
    sequence(:name) { |n| "Example Merch #{n}" }
    price { 9999 }
    event
  end

  factory :material do
    name { |n| "Material #{n}" }
  end
end
