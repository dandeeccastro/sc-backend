FactoryBot.define do
  factory :attendee, class: "User" do
    sequence(:name) { |n| "Usuário #{n}" }
    email { "#{name.downcase}@test.com" }
    password { 'senha123' }
    permissions { User::ATTENDEE }
    cpf { CPF.generate }
    ocupation { 'Estudante de ensino superior' }
    institution { 'UFRJ' }
  end

  factory :admin, class: "User" do
    sequence(:name) { |n| "Usuário #{n}" }
    email { "#{name.downcase}@test.com" }
    password { 'senha123' }
    permissions { User::ADMIN }
    cpf { CPF.generate }
    ocupation { 'Estudante de ensino superior' }
    institution { 'UFRJ' }
  end
end
