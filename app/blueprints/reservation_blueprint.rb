class ReservationBlueprint < Blueprinter::Base
  identifier :id
  fields :delivered, :amount, :options
  association :user, blueprint: UserBlueprint
  association :merch, blueprint: MerchBlueprint
end
