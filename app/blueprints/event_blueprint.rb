class EventBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :slug, :start_date, :end_date, :registration_start_date
  field :banner_url do |event| event.banner_url end

  view :event do
    field :talks do |event| event.schedule end
  end
end
