require 'rails_helper'
require 'swagger_helper'

describe 'Events API' do
  path '/events' do
    get 'listar eventos' do
      tags 'Eventos'
      response '200', 'listar todos os eventos' do
        let!(:events) { create_list(:event, 3) }
        run_test!
      end
    end
     
    post 'criar evento' do
      tags 'Eventos'
      security [token: []]
      consumes 'application/json'
      parameter name: :event, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          slug: { type: :string },
          start_date: { type: :string },
          end_date: { type: :string },
          registration_start_date: { type: :string },
          banner_url: { type: :file },
        },
        required: %w[name start_date end_date]
      }

      response '201', 'evento criado com sucesso' do
        let(:event) { { name: 'Evento teste', slug: 'evento-teste', start_date: DateTime.now, end_date: 1.week.from_now, registration_start_date: DateTime.now, banner_url: '' } }
        let(:Authorization) { authenticate(create(:admin))}
        run_test!
      end

      response '401', 'sem permissão para criar evento' do
        let(:event) { { name: 'Evento teste', slug: 'evento-teste', start_date: DateTime.now, end_date: 1.week.from_now, registration_start_date: DateTime.now, banner_url: '' } }
        let(:Authorization) { authenticate(create(:attendee))}
        run_test!
      end

      response '422', 'parâmetros inválidos' do
        let(:event) { { name: 'Evento teste', slug: 'evento-teste', end_date: 1.week.from_now, registration_start_date: DateTime.now, banner_url: '' } }
        let(:Authorization) { authenticate(create(:admin))}
        run_test!
      end
    end
  end

  path '/events/{id}' do
    put 'atualizar evento' do
      tags 'Eventos'
      security [token: []]
      parameter name: :id, in: :path, type: :string
      parameter name: :event, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string },
          slug: { type: :string },
          start_date: { type: :string },
          end_date: { type: :string },
          registration_start_date: { type: :string },
          banner_url: { type: :file },
        },
        required: %w[id]
      }

      response '200', 'evento atualizado com sucesso' do
        let(:id) { create(:event).id }
        let(:Authorization) { authenticate(create(:admin))}
        let(:event) { { name: 'Outro Nome', slug: 'mudei-o-slug' } }
        run_test!
      end

      response '401', 'sem permissão para atualizar evento' do
        let(:id) { create(:event).id }
        let(:Authorization) { authenticate(create(:attendee))}
        let(:event) { { name: 'Outro Nome', slug: 'mudei-o-slug' } }
        run_test!
      end
    end

    delete 'deleta evento' do
      tags 'Eventos'
      security [token: []]
      parameter name: :id, in: :path, type: :string

      response '200', 'evento deletado com sucesso' do
        let(:id) { create(:event).id }
        let(:Authorization) { authenticate(create(:admin))}
        run_test!
      end

      response '401', 'sem permissão para remover evento' do
        let(:id) { create(:event).id }
        let(:Authorization) { authenticate(create(:attendee))}
        run_test!
      end
    end
  end

  path '/events/{slug}' do
    get 'mostra evento' do
      tags 'Eventos'
      parameter name: :slug, in: :path, type: :string

      response '200', 'mostra evento com sucesso' do
        let(:slug) { create(:event).slug }
        run_test!
      end
    end
  end

  path '/events/{slug}/users' do
    get 'lista usuários do evento' do
      tags %w[Eventos Usuários]
      security [token: []]
      parameter name: :slug, in: :path, type: :string

      response '200', 'lista usuários do evento com sucesso' do
        let(:slug) { create(:event).slug }
        let(:Authorization) { authenticate(create(:admin)) }
        run_test!
      end

      response '401', 'sem permissão para executar a ação' do
        let(:slug) { create(:event).slug }
        let(:Authorization) { authenticate(create(:attendee)) }
        run_test!
      end
    end
  end
end
