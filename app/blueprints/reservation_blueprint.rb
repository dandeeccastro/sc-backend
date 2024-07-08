class ReservationBlueprint < Blueprinter::Base
  identifier :id
  association :user, blueprint: UserBlueprint
  association :merch, blueprint: MerchBlueprint
end
