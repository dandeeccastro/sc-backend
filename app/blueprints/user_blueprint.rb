class UserBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :email, :dre, :permissions, :ocupation, :institution

  view :with_vacancy do
    field :vacancy do |user, options|
      Vacancy.where(user:, talk_id: options[:talk].id)
    end
  end
end
