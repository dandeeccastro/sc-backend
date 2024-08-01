FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "Evento #{n}" }
    slug { name.parameterize }
    start_date { DateTime.now }
    end_date { 2.weeks.from_now }
    registration_start_date { DateTime.now }
  end
end
