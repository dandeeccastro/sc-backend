class NotificationBlueprint < Blueprinter::Base
  fields :description
  association :user, blueprint: UserBlueprint
end
