class ReservationBlueprint < Blueprinter::Base
  identifier :id
  fields :delivered
  association :user, blueprint: UserBlueprint
  association :merch, blueprint: MerchBlueprint
end
