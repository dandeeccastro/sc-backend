class TeamBlueprint < Blueprinter::Base
  association :staffs, blueprint: StaffBlueprint
end
