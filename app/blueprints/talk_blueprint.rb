class TalkBlueprint < Blueprinter::Base
  identifier :id
  fields :title, :start_date, :end_date, :type, :category
  association :type, blueprint: TypeBlueprint
  association :category, blueprint: CategoryBlueprint
  association :location, blueprint: LocationBlueprint
  association :speaker, blueprint: SpeakerBlueprint

  view :detailed do
    fields :vacancy_limit, :description
    field :rating do |talk| talk.rating end
  end
end
