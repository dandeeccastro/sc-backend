class VacancyBlueprint < Blueprinter::Base
  association :attendee, blueprint: AttendeeBlueprint
  association :staff, blueprint: StaffBlueprint
  association :talk, blueprint: TalkBlueprint
end
