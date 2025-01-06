require 'rails_helper'
require 'swagger_helper'

describe 'Auth API' do
  path '/login' do
    post 'faz o login do usuário' do
      tags 'Autenticação'
      consumes 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          cpf: { type: :string },
          password: { type: :string },
        },
        required: %w[cpf password]
      }

      response '200', 'usuário logado com sucesso' do
        let(:my_user) { create(:user) }
        let(:user) { { cpf: my_user.cpf, password: my_user.password }}
        run_test!
      end

      response '401', 'credenciais incorretas' do
        let(:user) { { cpf: '11111111111', password: 'senha123' }}
        run_test!
      end
    end
  end
end
