class VacancyBlueprint < Blueprinter::Base
  association :talk, blueprint: TalkBlueprint

  view :staff do
    fields :presence
    association :user, blueprint: UserBlueprint
  end
end
