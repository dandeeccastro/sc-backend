class TalkBlueprint < Blueprinter::Base
  identifier :id

  view :simple do
    fields :title, :start_date, :end_date, :type, :category
    association :type, blueprint: TypeBlueprint
    association :category, blueprint: CategoryBlueprint
    association :location, blueprint: LocationBlueprint
    association :speaker, blueprint: SpeakerBlueprint
  end

  view :detailed do
    include_view :simple
    fields :vacancy_limit, :description
    field :rating do |talk| talk.rating end
  end
end
