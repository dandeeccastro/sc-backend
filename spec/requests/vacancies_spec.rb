require 'swagger_helper'

describe 'Vacancies API' do
  path '/vacancies/{id}' do
    let(:event) { create(:event) }
    let(:location) { create(:location) }
    let(:type) { create(:type) }
    let(:talk) { create(:talk, event:, location:, type:)}
    let(:admin) { create(:admin) }
    let(:vacancy) { create(:vacancy, talk:, user: admin) }

    delete 'remover uma vaga' do
      tags 'Vaga'
      security [token: []]
      consumes 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '200', 'remoção feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:id) { vacancy.id }
        run_test!
      end

      response '401', 'sem permissão para remover' do
        let(:Authorization) { '' }
        let(:id) { vacancy.id }
        run_test!
      end
    end
  end

  path '/vacancies/me' do
    let(:event) { create(:event) }
    let(:location) { create(:location) }
    let(:type) { create(:type) }
    let(:talk) { create(:talk, event:, location:, type:)}
    let(:admin) { create(:admin) }
    let(:vacancy) { create(:vacancy, talk:, user: admin) }

    get 'mostrar vagas do usuário atual' do
      tags 'Vaga'
      security [token: []]
      consumes 'application/json'
      parameter name: :event_slug, in: :query, type: :string

      response '200', 'listagem feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:event_slug) { event.slug }
        run_test!
      end

      response '401', 'sem permissão para listar vagas' do
        let(:Authorization) { '' }
        let(:event_slug) { event.slug }
        run_test!
      end
    end
  end

  path '/participate' do
    let(:event) { create(:event) }
    let(:location) { create(:location) }
    let(:type) { create(:type) }
    let(:talk) { create(:talk, event:, location:, type:)}
    let(:admin) { create(:admin) }
    let(:vacancy) { create(:vacancy, talk:, user: admin) }

    post 'criar vaga numa atividade' do
      tags 'Vaga'
      security [token: []]
      consumes 'application/json'
      parameter name: :participation, in: :body, schema: {
        type: :object,
        properties: {
          talk_ids: { type: :array, items: { type: :integer } },
          event_slug: { type: :string }
        }
      }

      response '200', 'criação de vaga feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:participation) { { 
          event_slug: event.slug,
          talk_ids: [talk.id]
        } }

        run_test!
      end

      response '401', 'sem permissão para criar' do
        let(:Authorization) { '' }
        let(:participation) { { 
          event_slug: event.slug,
          talk_ids: [talk.id]
        } }

        run_test!
      end

      response '422', 'parâmetros inválidos' do
        let(:Authorization) { authenticate(admin) }
        let(:participation) { { 
          event_slug: event.slug,
        } }

        run_test!
      end
    end
  end

  path '/validate' do
    let(:event) { create(:event) }
    let(:location) { create(:location) }
    let(:type) { create(:type) }
    let(:talk) { create(:talk, event:, location:, type:)}
    let(:admin) { create(:admin) }
    let(:vacancies) { create_list(:vacancy, 4, talk:, user: create(:attendee)) }

    post 'validar presença de uma vaga numa atividade' do
      tags 'Vaga'
      security [token: []]
      consumes 'application/json'
      parameter name: :validation, in: :body, schema: {
        type: :object,
        properties: {
          talk_id: { type: :integer },
          presence: { type: :array, items: { type: :integer } },
          absence: { type: :array, items: { type: :integer } }
        }
      }

      response '200', 'validação de presença feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:validation) { {
          talk_id: talk.id,
          presence: [1, 2],
          absence: [3, 4],
        } }
        run_test!
      end

      response '401', 'sem permissão para validar presença' do
        let(:Authorization) { '' }
        let(:validation) { {
          talk_id: talk.id,
          presence: [1, 2],
          absence: [3, 4],
        } }
        run_test!
      end
    end
  end
end
