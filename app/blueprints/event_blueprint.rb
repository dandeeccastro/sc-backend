class EventBlueprint < Blueprinter::Base
  fields :name, :slug, :start_date, :end_date

  association :team, blueprint: TeamBlueprint
end
