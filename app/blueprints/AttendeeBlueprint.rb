class AttendeeBlueprint < Blueprinter::Base
  association :user, blueprint: UserBlueprint
end
