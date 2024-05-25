class EventBlueprint < Blueprinter::Base
  fields :name, :slug

  association :team, blueprint: TeamBlueprint
end
