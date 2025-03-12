class MerchBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :price, :stock, :limit, :custom_fields

  field :image_url do |merch| merch.image_url end

  view :staff do
    field :reservations do |merch| Reservation.where(merch:).sum(:amount) end
  end
end
