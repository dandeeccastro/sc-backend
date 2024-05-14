class ReservationBlueprint < Blueprinter::Base
  association :user, blueprint: UserBlueprint
  association :merch, blueprint: MerchBlueprint
end
