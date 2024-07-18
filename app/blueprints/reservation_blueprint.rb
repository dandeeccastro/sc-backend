class ReservationBlueprint < Blueprinter::Base
  identifier :id
  fields :delivered, :size, :amount
  association :user, blueprint: UserBlueprint
  association :merch, blueprint: MerchBlueprint
end
