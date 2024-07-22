FactoryBot.define do
  factory :type do
    sequence(:name) { |n| "Tipo #{n}" }
    sequence(:color) { |n| "##{n.to_s(16).rjust(6,'0')}" }
  end
end
