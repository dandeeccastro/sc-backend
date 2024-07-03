class NotificationBlueprint < Blueprinter::Base
  fields :description, :created_at, :title
  association :user, blueprint: UserBlueprint
end
