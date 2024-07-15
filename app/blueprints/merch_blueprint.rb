class MerchBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :price, :stock

  field :image_url do |merch| merch.image_url end
end
