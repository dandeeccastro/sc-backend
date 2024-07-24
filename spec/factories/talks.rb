FactoryBot.define do
  factory :talk do
    sequence(:title) { |n| "Palestra #{n}" }
    description { "Descrição da palestra #{title}"}
    start_date { DateTime.now }
    end_date { 1.hour.from_now }
    vacancy_limit { 50 }

    factory :talk_with_event do
      event
      location
      type

      start_date { event.start_date + 1.hour }
      end_date { event.start_date + 2.hour }

      speaker { create(:speaker, event: event) } 
    end
  end
end
