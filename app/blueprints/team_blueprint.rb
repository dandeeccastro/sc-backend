class TeamBlueprint < Blueprinter::Base
  association :users, blueprint: UserBlueprint
end
