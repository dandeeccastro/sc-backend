FactoryBot.define do
  factory :reservation do
    amount { 10 }
    options { { Example: 'Value' }}
    delivered { false }
  end
end
