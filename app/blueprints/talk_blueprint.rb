class TalkBlueprint < Blueprinter::Base
  identifier :id

  view :simple do
    fields :title, :start_date, :end_date
  end

  view :detailed do
    include_view :simple
    fields :vacancy_limit, :description
    field :rating do |talk| talk.rating end
    association :location, blueprint: LocationBlueprint
  end
end
