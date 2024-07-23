FactoryBot.define do
  factory :team do
    transient do
      users_count { 3 }
    end

    users do
      Array.new(users_count) do
        association(:staff, teams: [instance])
      end
    end
  end
end
