class SpeakerBlueprint < Blueprinter::Base
  identifier :id
  fields :name

  view :detailed do
    fields :bio, :image, :email
  end
end
