FactoryBot.define do
  factory :user do
    name { 'Lorem Ipsum' }
    email { 'lorem.ipsum@gmail.com' }
    password { 'senha123' }
    dre { '12312312312' }
  end
end
