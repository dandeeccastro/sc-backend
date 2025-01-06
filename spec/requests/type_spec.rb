require 'swagger_helper'

describe 'Types API' do
  let!(:admin) { create(:admin) }
  before { @token = authenticate(admin) }

  path '/type' do
    post 'criar tipo' do
      tags 'Tipos'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :type, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          color: { type: :string }
        },
        required: %w[name color]
      }

      response '201', 'tipo criado com sucesso' do
        let(:Authorization) { @token }
        let(:type) { { name: 'Testing', color: 'orange' } }
        run_test!
      end

      response '401', 'sem permissão para criar tipo' do
        schema '$ref': '#/components/schemas/error'
        let(:Authorization) { '' }
        let(:type) { { name: 'Testing', color: 'orange' } }
        run_test!
      end

      response '422', 'parâmetros inválidos' do
        schema '$ref': '#/components/schemas/error'
        let(:type) { { color: 'orange' } }
        let(:Authorization) { @token }
        run_test!
      end
    end
  end

  path '/type/{id}' do
    put 'atualizar tipo' do
      tags 'Tipos'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :type,in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string },
          color: { type: :string }
        },
        required: %w[id name color]
      }

      response '200', 'tipo atualizado com sucesso' do
        let(:id) { Type.create(name: 'Testing', color: 'orange').id }
        let(:type) { { id:, name: 'Changed', color: 'purple' } }
        let(:Authorization) { @token }
        run_test!
      end

      response '401', 'sem permissão para atualizar tipo' do
        schema '$ref': '#/components/schemas/error'
        let(:id) { Type.create(name: 'Testing', color: 'orange').id }
        let(:type) { { id:, name: 'Changed', color: 'purple' } }
        let(:Authorization) { authenticate(create(:attendee)) }
        run_test!
      end
    end

    delete 'deletar tipo' do
      tags 'Tipos'
      security [token: []]
      parameter name: :id, in: :path, type: :string
      produces 'application/json'

      response '200', 'tipo deletado com sucesso' do
        let(:id) { Type.create(name: 'Testing', color: 'orange').id }
        let(:Authorization) { @token }
        run_test!
      end

      response '401', 'sem permissão para remover tipo' do
        schema '$ref': '#/components/schemas/error'
        let(:id) { Type.create(name: 'Testing', color: 'orange').id }
        let(:Authorization) { authenticate(create(:attendee)) }
        run_test!
      end
    end
  end
end
