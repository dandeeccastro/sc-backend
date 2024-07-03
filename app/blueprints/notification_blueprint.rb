class NotificationBlueprint < Blueprinter::Base
  fields :description, :created_date
  association :user, blueprint: UserBlueprint
end
