class VacancyBlueprint < Blueprinter::Base
  identifier :id
  association :talk, blueprint: TalkBlueprint

  view :staff do
    fields :presence
    association :user, blueprint: UserBlueprint
  end
end
