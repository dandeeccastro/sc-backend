class TeamBlueprint < Blueprinter::Base
  identifier :id
  association :users, blueprint: UserBlueprint
end
