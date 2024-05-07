class VacancyBlueprint < Blueprinter::Base
  fields :presence
  association :user, blueprint: UserBlueprint
  association :talk, blueprint: TalkBlueprint
end
