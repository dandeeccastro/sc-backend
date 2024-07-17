class TalkBlueprint < Blueprinter::Base
  identifier :id
  fields :title, :start_date, :end_date, :description, :vacancy_limit

  association :type, blueprint: TypeBlueprint
  association :categories, blueprint: CategoryBlueprint
  association :location, blueprint: LocationBlueprint
  association :speaker, blueprint: SpeakerBlueprint, view: :detailed

  view :detailed do
    fields :description
    field :rating do |talk| talk.rating end
    field :vacancy_count do |talk| talk.users.count end
  end

  view :staff do
    include_view :detailed
    field :users do |talk| UserBlueprint.render_as_hash(talk.users) end
  end
end
