require 'swagger_helper'

describe 'Users API' do
  path '/user' do
    get 'listar usuários' do
      tags 'Usuário'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'listagem de usuários com sucesso' do
        let(:Authorization) { authenticate(create(:admin)) }
        run_test!
      end
      
      response '401', 'sem permissão para listar' do
        schema '$ref': '#/components/schemas/error'
        let(:Authorization) { authenticate(create(:attendee)) }
        run_test!
      end
    end
  end

  path '/user/{id}' do
    get 'mostrar usuário' do
      tags 'Usuário'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'mostrar usuário com sucesso' do
        let(:attendee) { create(:attendee) }
        let(:id) { attendee.id }
        let(:Authorization) { authenticate(create(:admin)) }
        run_test!
      end

      response '401', 'sem permissão para listar' do
        schema '$ref': '#/components/schemas/error'
        let(:attendee) { create(:attendee) }
        let(:id) { attendee.id }
        let(:Authorization) { authenticate(create(:attendee)) }
        run_test!
      end
    end

    put 'atualizar usuário' do
      tags 'Usuário'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          cpf: { type: :string },
          dre: { type: :string },
          ocupation: { type: :string },
          institution: { type: :string },
        },
      }

      response '200', 'usuário atualizado com sucesso' do
        let(:attendee) { create(:attendee) }
        let(:id) { attendee.id }
        let(:Authorization) { authenticate(attendee) }
        let(:user) { { name: 'Outro nome' }}
        run_test!
      end

      response '401', 'sem permissão para atualizar' do
        schema '$ref': '#/components/schemas/error'
        let(:attendee) { create(:attendee) }
        let(:id) { attendee.id }
        let(:Authorization) { authenticate(create(:attendee)) }
        let(:user) { { name: 'Outro nome' }}
        run_test!
      end
    end

    delete 'remover usuário' do
      tags 'Usuário'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'usuário deletado com sucesso' do
        let(:attendee) { create(:attendee) }
        let(:id) { attendee.id }
        let(:Authorization) { authenticate(attendee) }
        run_test!
      end

      response '401', 'sem permissão para listar' do
        schema '$ref': '#/components/schemas/error'
        let(:attendee) { create(:attendee) }
        let(:id) { attendee.id }
        let(:Authorization) { authenticate(create(:attendee)) }
        run_test!
      end
    end
  end
  
  path '/admin' do
    get 'verifica se usuário é admin' do
      tags 'Usuário'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      response '200', 'retorna boolean de verificação' do
        let(:Authorization) { authenticate(create(:attendee)) }
        run_test!
      end
    end
  end
end
