class SpeakerBlueprint < Blueprinter::Base
  identifier :id
  fields :name

  view :detailed do
    fields :bio, :email
    field :image_url do |speaker| speaker.image_url end
  end
end
