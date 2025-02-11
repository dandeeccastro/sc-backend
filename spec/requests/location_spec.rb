require 'swagger_helper'

describe 'Locations API' do
  path '/location' do
    let(:admin) { create(:admin) }

    get 'listar localizações' do
      tags 'Localização'
      security [token: []] 
      consumes 'application/json'

      response '200', 'listagem de localização feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        run_test!
      end

      response '401', 'sem permissão para listar' do
        let(:Authorization) { '' }
        run_test!
      end
    end

    post 'criar localização' do
      tags 'Localização'
      security [token: []] 
      consumes 'application/json'

      parameter name: :location, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      response '201', 'criação feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:location) { { name: 'Lugar' } }
        run_test!
      end
      
      response '401', 'sem permissão para criar' do
        let(:Authorization) { '' }
        let(:location) { { name: 'Lugar' } }
        run_test!
      end
    end
  end

  path '/location/{id}' do
    let(:admin) { create(:admin) }
    let(:location) { create(:location) }

    put 'atualizar localização' do
      tags 'Localização'
      security [token: []] 
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      parameter name: :location_data, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        }
      }

      response '201', 'atualização feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:location_data) { { name: 'Lugar' } }
        let(:id) { location.id }
        run_test!
      end
      
      response '401', 'sem permissão para atualizar' do
        let(:Authorization) { '' }
        let(:location_data) { { name: 'Lugar' } }
        let(:id) { location.id }
        run_test!
      end
    end

    delete 'remover localização' do
      tags 'Localização'
      security [token: []] 
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'remoção feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:id) { location.id }
        run_test!
      end
      
      response '401', 'sem permissão para remover' do
        let(:Authorization) { '' }
        let(:id) { location.id }
        run_test!
      end
    end
  end
end
