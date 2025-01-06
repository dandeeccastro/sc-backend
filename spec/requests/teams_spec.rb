require 'swagger_helper'

describe 'Teams API' do
  path '/teams' do
    get 'listar times' do
      tags 'Equipe'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'lista equipes cadastradas no Venti' do
        let(:Authorization) { authenticate(create(:admin)) }
        run_test!
      end

      response '401', 'sem permissão para listar equipes' do
        schema '$ref': '#/components/schemas/error'
        let(:Authorization) { '' }
        run_test!
      end
    end

    post 'criar time' do
      tags 'Equipe'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          user_ids: { type: :array, items: { type: :integer } }
        }
      }

      response '201', 'equipe criada com sucesso' do
        let(:Authorization) { authenticate(create(:admin)) }
        let!(:people) { create_list(:attendee, 3) }
        let(:team) { { user_ids: [1,2,3]} }
        run_test!
      end

      response '401', 'sem permissão para criar equipe' do
        schema '$ref': '#/components/schemas/error'
        let(:Authorization) { '' }
        let(:team) { { user_ids: [1,2,3]} }
        run_test!
      end
    end
  end

  path '/teams/{slug}' do
    get 'mostrar equipe do evento' do
      tags 'Equipe'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :slug, in: :path, type: :string

      response '200', 'equipe mostrada com sucesso' do
        let(:event) { create(:event)}
        let(:slug) { event.slug }
      end

      response '401', 'sem permissão para mostrar equipe' do
        schema '$ref': '#/components/schemas/error'
        let(:event) { create(:event)}
        let(:slug) { event.slug }
        let(:Authorization) { '' }
        run_test!
      end
    end
  end

  path '/teams/{id}' do
    put 'atualizar equipe' do
      tags 'Equipe'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          user_ids: { type: :array, items: { type: :integer } }
        }
      }

      response '200', 'equipe atualizada com sucesso' do
        let(:Authorization) { authenticate(create(:admin))}
        let!(:people) { create_list(:attendee, 3) }
        let(:event) { create(:event) }
        let(:id) { event.team.id }
        let(:team) { { user_ids: [1,2], id: event.team.id } }
        run_test!
      end

      response '401', 'sem permissão para atualizar equipe' do
        schema '$ref': '#/components/schemas/error'
        let(:Authorization) { '' }
        let(:event) { create(:event) }
        let(:id) { event.team.id }
        let(:team) { { user_ids: [1,2], id: event.team.id } }
        run_test!
      end
    end

    delete 'deletar equipe' do
      tags 'Equipe'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '200', 'equipe deletada com sucesso' do
        let(:Authorization) { authenticate(create(:admin)) }
        let(:event) { create(:event) }
        let(:id) { event.team.id }
        run_test!
      end

      response '401', 'sem permissão para deletar equipe' do
        schema '$ref': '#/components/schemas/error'
        let(:Authorization) { '' }
        let(:event) { create(:event) }
        let(:id) { event.team.id }
        run_test!
      end
    end
  end
end
