class EventBlueprint < Blueprinter::Base
  fields :name, :slug, :start_date, :end_date

  view :event do
    association :talks, blueprint: TalkBlueprint
  end
end
