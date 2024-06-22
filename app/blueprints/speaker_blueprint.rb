class SpeakerBlueprint < Blueprinter::Base
  fields :name

  view :detailed do
    fields :bio, :image
  end
end
