FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Categoria #{n}" }
    sequence(:color) { |n| "##{n.to_s(16).rjust(6,'0')}" }

    factory :category_with_event do
      event
    end
  end
end
