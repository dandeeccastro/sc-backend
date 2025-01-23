require 'swagger_helper'

describe 'Reservation API' do
  path '/events/{slug}/reservations' do
    let(:event) { create(:event) }
    let(:admin) { create(:admin) }

    get 'mostrar todas as reservas de um evento' do
      tags 'Reserva'
      security [token: []]
      consumes 'application/json'

      parameter name: :slug, in: :path, type: :string

      response '200', 'listagem feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:slug) { event.slug }
        run_test!
      end

      response '401', 'sem permissão para listar reservas' do
        let(:Authorization) { '' }
        let(:slug) { event.slug }
        run_test!
      end
    end

    post 'criar uma reserva para si mesmo' do
      tags 'Reserva'
      security [token: []]
      consumes 'application/json'
      parameter name: :slug, in: :path, type: :string

      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          merch_id: { type: :integer },
          delivered: { type: :boolean },
          amount: { type: :integer },
          options: { type: :object },
        },
      }

      response '201', 'reserva criada com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:slug) { event.slug }
        let(:reservation) { {
          merch_id: create(:merch, event: event).id,
          delivered: false,
          amount: 10,
          options: {},
        } }
        run_test!
      end

      response '401', 'sem permissão para criar reservas' do
        let(:Authorization) { '' }
        let(:slug) { event.slug }
        let(:reservation) { {
          merch_id: create(:merch, event: event).id,
          delivered: false,
          amount: 10,
          options: {},
        } }
        run_test!
      end

      response '422', 'parâmetros inválidos' do
        let(:Authorization) { authenticate(admin) }
        let(:slug) { event.slug }
        let(:reservation) { {
          merch_id: create(:merch, event: event).id,
          delivered: false,
          amount: -10,
          options: {},
        } }
        run_test!
      end
    end
  end

  path '/events/{slug}/reservations/{id}' do
    let(:event) { create(:event) }
    let(:admin) { create(:admin) }
    let(:merch) { create(:merch, event:) }
    let(:admin_reservation) { create(:reservation, merch:, user: admin) }

    get 'mostrar sua reserva' do
      tags 'Reserva'
      security [token: []]
      consumes 'application/json'
      parameter name: :slug, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'listagem feita com sucesso' do
        let(:slug) { event.slug }
        let(:id) { admin_reservation.id }
        let(:Authorization) { authenticate(admin) }
        run_test!
      end

      response '401', 'sem permissão para mostrar reservas' do
        let(:slug) { event.slug }
        let(:id) { admin_reservation.id }
        let(:Authorization) { '' }
        run_test!
      end
    end

    put 'atualizar sua reserva' do
      tags 'Reserva'
      security [token: []]
      consumes 'application/json'
      parameter name: :slug, in: :path, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          merch_id: { type: :integer },
          delivered: { type: :boolean },
          amount: { type: :integer },
        },
      }

      response '200', 'reserva atualizada com sucesso' do
        let(:slug) { event.slug }
        let(:id) { admin_reservation.id }
        let(:reservation) { { delivered: true } }
        let(:Authorization) { authenticate(admin) }
        run_test!
      end

      response '401', 'sem permissão para atualizar reserva' do
        let(:slug) { event.slug }
        let(:id) { admin_reservation.id }
        let(:reservation) { { delivered: true } }
        let(:Authorization) { '' }
        run_test!
      end

      response '422', 'parâmetros inválidos' do
        let(:slug) { event.slug }
        let(:id) { admin_reservation.id }
        let(:reservation) { { amount: -123 } }
        let(:Authorization) { authenticate(admin) }
        run_test!
      end
    end
    
    delete 'remover sua reserva' do
      tags 'Reserva'
      security [token: []]
      consumes 'application/json'
      parameter name: :slug, in: :path, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'remoção feita com sucesso' do
        let(:slug) { event.slug }
        let(:id) { admin_reservation.id }
        let(:Authorization) { authenticate(admin) }
        run_test!
      end

      response '401', 'sem permissão para listar reservas' do
        let(:slug) { event.slug }
        let(:id) { admin_reservation.id }
        let(:Authorization) { '' }
        run_test!
      end
    end
  end
end
