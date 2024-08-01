class TalkBlueprint < Blueprinter::Base
  identifier :id
  fields :title, :start_date, :end_date, :description, :vacancy_limit
  field :participants do |talk| talk.participants end

  association :type, blueprint: TypeBlueprint
  association :categories, blueprint: CategoryBlueprint
  association :location, blueprint: LocationBlueprint
  association :speakers, blueprint: SpeakerBlueprint, view: :detailed

  view :detailed do
    field :rating do |talk| talk.rating end
    field :vacancy_count do |talk| talk.users.count end
  end

  view :staff do
    include_view :detailed
    field :users do |talk| UserBlueprint.render_as_hash(talk.users) end
  end
end
