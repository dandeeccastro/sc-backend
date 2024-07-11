class EventBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :slug, :start_date, :end_date, :registration_start_date

  view :event do
    field :talks do |event| event.schedule end
  end
end
