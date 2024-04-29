class EventBlueprint < Blueprinter::Base
  fields :name

  association :team, blueprint: TeamBlueprint
end
