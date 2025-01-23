require 'swagger_helper'

describe 'Notifications API' do
  let!(:admin) { create(:admin) }
  let!(:event) { create(:event) }
  before { @token = authenticate(admin) }

  path '/events/{slug}/notifications/staff' do
    get 'listar notificações como staff' do
      tags 'Notificações'
      security [token: []]
      parameter name: :slug, in: :path, type: :string

      response '200', 'listagem de notificações feita com sucesso' do
        let(:Authorization) { @token }
        let(:slug) { event.slug }
        run_test!
      end

      response '401', 'sem permissão para listar notificações' do
        schema '$ref': '#/components/schemas/error'
        let(:Authorization) { '' }
        let(:slug) { event.slug }
        run_test!
      end
    end
  end

  path '/events/{slug}/notifications' do
    get 'listar notificações' do
      tags 'Notificações'
      security [token: []]
      produces 'application/json'
      parameter name: :slug, in: :path, type: :string

      response '200', 'listagem de notificações feita com sucesso' do
        let(:Authorization) { @token }
        let(:slug) { event.slug }
        run_test!
      end

      response '401', 'sem permissão para listar notificações' do
        schema '$ref': '#/components/schemas/error'
        let(:Authorization) { '' }
        let(:slug) { event.slug }
        run_test!
      end
    end

    post 'criar nova notificação' do
      tags 'Notificações'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :slug, in: :path, type: :string

      parameter name: :notification, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          talk_id: { type: :string },
        },
        required: %w[title description]
      }

      response '201', 'criação de notificação feita com sucesso' do
        let(:notification) { { title: 'Teste', description: 'Testando descrição' } }
        let(:Authorization) { @token }
        let(:slug) { event.slug }
        run_test!
      end

      response '401', 'sem permissão para criar notificações' do
        schema '$ref': '#/components/schemas/error'
        let(:notification) { { title: 'Teste', description: 'Testando descrição' } }
        let(:Authorization) { '' }
        let(:slug) { event.slug }
        run_test!
      end

      response '422', 'parâmetros inválidos' do
        schema '$ref': '#/components/schemas/error'
        let(:notification) { { title: 'Teste' } }
        let(:Authorization) { @token }
        let(:slug) { event.slug }
        run_test!
      end
    end
  end

  path '/events/{slug}/notifications/{id}' do
    put 'atualizar notificação' do
      tags 'Notificações'
      security [token: []]
      produces 'application/json'
      parameter name: :slug, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      parameter name: :notification, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          talk_id: { type: :string },
        },
      }


      response '200', 'atualização de notificação feita com sucesso' do
        let(:notification) { { title: 'Teste', description: 'Testando descrição' } }
        let(:id) { create(:notification, event: event, user: admin).id }
        let(:Authorization) { @token }
        let(:slug) { event.slug }
        run_test!
      end

      response '401', 'sem permissão para atualizar notificações' do
        schema '$ref': '#/components/schemas/error'
        let(:notification) { { title: 'Teste', description: 'Testando descrição' } }
        let(:Authorization) { '' }
        let(:id) { create(:notification, event: event, user: admin).id }
        let(:slug) { event.slug }
        run_test!
      end
    end

    delete 'remover notificação' do
      tags 'Notificações'
      security [token: []]
      produces 'application/json'
      parameter name: :slug, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'remoção de notificação feita com sucesso' do
        let(:id) { create(:notification, event: event, user: admin).id }
        let(:Authorization) { @token }
        let(:slug) { event.slug }
        run_test!
      end

      response '401', 'sem permissão para deletar notificações' do
        schema '$ref': '#/components/schemas/error'
        let(:id) { create(:notification, event: event, user: admin).id }
        let(:Authorization) { '' }
        let(:slug) { event.slug }
        run_test!
      end
    end
  end
end
