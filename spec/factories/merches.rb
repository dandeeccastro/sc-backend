FactoryBot.define do
  factory :merch do
    sequence(:name) { |n| "Mercadoria #{n}" }
    price { 2000 }
    stock { 50 }
    custom_fields { { Tamanho: %w[P M G GG GGG] } }

    factory :merch_with_event do
      event
    end
  end
end
