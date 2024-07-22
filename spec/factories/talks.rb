FactoryBot.define do
  factory :talk do
    sequence(:title) { |n| "Palestra #{n}" }
    description { "Descrição da palestra #{title}"}
    start_date { DateTime.now }
    end_date { 1.hour.from_now }

    association :event
    association :location
    association :speaker
    association :type
  end
end
