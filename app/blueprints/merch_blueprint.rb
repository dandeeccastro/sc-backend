class MerchBlueprint < Blueprinter::Base
  fields :name, :price

  association :event, blueprint: EventBlueprint
end
