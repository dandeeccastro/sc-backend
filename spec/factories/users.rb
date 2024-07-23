FactoryBot.define do
  factory :user, aliases: [:attendee] do
    sequence(:name) { |n| "Usuário #{n}" }
    email { "#{name.downcase}@test.com" }
    password { 'senha123' }
    permissions { User::ATTENDEE }
    cpf { CPF.generate }
    ocupation { 'Estudante de ensino superior' }
    institution { 'UFRJ' }

    factory :staff do
      permissions { User::STAFF }
    end

    factory :staff_leader do
      permissions { User::STAFF_LEADER }
    end

    factory :admin do
      permissions { User::ADMIN }
    end
  end
end
