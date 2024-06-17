class EventBlueprint < Blueprinter::Base
  fields :id, :name, :slug, :start_date, :end_date

  view :event do
    association :talks, blueprint: TalkBlueprint
  end
end
