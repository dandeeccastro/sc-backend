class NotificationBlueprint < Blueprinter::Base
  fields :description, :created_at, :title

  view :detailed do
    association :talk, blueprint: TalkBlueprint
  end
end
