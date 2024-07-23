FactoryBot.define do
  factory :speaker do
    sequence(:name) { |n| "Palestrante #{n}" }
    bio { "Bio exemplo do palestrante #{name}" }
    email { "#{name.downcase}@test.com" }
  end
end
