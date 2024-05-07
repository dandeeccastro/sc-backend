class VacancyBlueprint < Blueprinter::Base
  fields :presence
  association :attendee, blueprint: AttendeeBlueprint
  association :talk, blueprint: TalkBlueprint
end
