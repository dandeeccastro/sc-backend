FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Categoria #{n}" }
    sequence(:color) { |n| "##{n.to_s(16).rjust(6,'0')}" }
    association :event
  end
end
