class TalkBlueprint < Blueprinter::Base
  fields :title, :description, :start_date, :end_date

  association :event, blueprint: EventBlueprint
  association :location, blueprint: LocationBlueprint
end
