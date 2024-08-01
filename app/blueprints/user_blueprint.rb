class UserBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :email, :dre, :permissions, :ocupation, :institution
end
