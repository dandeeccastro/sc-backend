class StaffBlueprint < Blueprinter::Base
  association :user, blueprint: UserBlueprint
end
