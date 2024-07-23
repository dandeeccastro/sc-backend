FactoryBot.define do
  factory :notification do
    title { 'Título da Notificação '}
    description { 'Descrição da Notificação '}

    factory :notification_with_user do
      association :user, factory: :staff
    end
  end
end
