class NotificationBlueprint < Blueprinter::Base
  fields :description, :created_date, :title
  association :user, blueprint: UserBlueprint
end
