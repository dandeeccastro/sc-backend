FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Localização #{n}" }
  end
end
