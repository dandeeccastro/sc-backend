require 'swagger_helper'

describe 'Talks API' do
  path '/events/{slug}/talks' do
    let(:event) { create(:event) }
    let(:talks) { create_list(:talks, 3, event: event) }

    get 'listar palestras de evento' do
      tags 'Palestras'
      parameter name: :slug, in: :path, type: :string

      response '200', 'palestras do evento listadas com sucesso' do
        let(:slug) { event.slug }
        run_test!
      end
    end
  end

  path '/talks' do
    post 'criar nova palestra' do
      tags 'Palestras'
      security [token: []]
      parameter name: :talk, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          start_date: { type: :datetime },
          end_date: { type: :datetime },
          vacancy_limit: { type: :integer },
          event_id: { type: :integer },
          location_id: { type: :integer },
          type_id: { type: :integer },
          speaker_ids: { type: :array, items: { type: :integer } },
          category_ids: { type: :array, items: { type: :integer } },
        },
        required: %w[title description start_date end_date vacancy_limit event_id location_id type_id speaker_ids category_ids]
      }

      response '201', 'palestra criada com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:talk) { {
          title: 'Título',
          description: 'Descrição',
          start_date: event.start_date,
          end_date: event.start_date + 1.hour,
          vacancy_limit: 50,
          event_id: event.id,
          location_id: location.id,
          type_id: type.id,
          speaker_ids: [speaker.id],
          category_ids: [category.id],
        } }
        run_test!
      end

      response '401', 'sem permissão para criar palestra' do
        let(:Authorization) { '' }
        let(:talk) { {
          title: 'Título',
          description: 'Descrição',
          start_date: event.start_date,
          end_date: event.start_date + 1.hour,
          vacancy_limit: 50,
          event_id: event.id,
          location_id: location.id,
          type_id: type.id,
          speaker_ids: [speaker.id],
          category_ids: [category.id],
        } }
        run_test!
      end

      response '422', 'parâmetros inválidos' do
        let(:Authorization) { authenticate(admin) }
        let!(:talk) { {
          title: 'Título',
          description: 'Descrição',
          start_date: '',
          end_date: '',
          vacancy_limit: -12,
          event_id: event.id,
          location_id: location.id,
          type_id: type.id,
          speaker_ids: [speaker.id],
          category_ids: [category.id],
        } }
        run_test!
      end
    end
  end

  path '/talks/{id}' do
    let(:event) { create(:event) }
    let(:talk) { create(:talk, event: event, location: create(:location), type: create(:type)) }
    let(:admin) { create(:admin) }

    get 'mostrar palestra' do
      tags 'Palestras'
      parameter name: :id, in: :path, type: :string

      response '200', 'palestra mostrada com sucesso' do
        let(:id) { talk.id }
        run_test!
      end
    end

    put 'atualizar palestra' do
      tags 'Palestras'
      parameter name: :id, in: :path, type: :string
      security [token: []]

      response '200', 'palestra atualizada com sucesso' do
      end

      response '401', 'sem permissão para atualizar palestra' do
      end

      response '422', 'parâmetros inválidos' do
      end
    end

    delete 'remover palestra' do
      tags 'Palestras'
      parameter name: :id, in: :path, type: :string
      security [token: []]

      response '200', 'palestra deletada com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:id) { talk.id }
        run_test!
      end

      response '401', 'sem permissão para deletar palestra' do
        let(:Authorization) { '' }
        let(:id) { talk.id }
        run_test!
      end
    end
  end

  path '/talks/{id}/staff' do
    let(:event) { create(:event) }
    let(:talk) { create(:talk, event: event, location: create(:location), type: create(:type)) }
    let(:admin) { create(:admin) }

    get 'mostrar palestra como staff' do
      tags 'Palestras'
      parameter name: :id, in: :path, type: :string
      security [token: []]

      response '200', 'palestra mostrada com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:id) { talk.id }
        run_test!
      end

      response '401', 'sem permissão para mostrar palestra' do
        let(:Authorization) { '' }
        let(:id) { talk.id }
        run_test!
      end
    end
  end

  path '/talks/{id}/status' do
    let(:event) { create(:event) }
    let(:talk) { create(:talk, event: event, location: create(:location), type: create(:type)) }
    let(:admin) { create(:admin) }

    get 'mostrar status da palestra' do
      tags 'Palestras'
      parameter name: :id, in: :path, type: :string
      security [token: []]

      response '200', 'status mostrado com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:id) { talk.id }
        run_test!
      end

      response '401', 'sem permissão para mostrar status' do
        let(:Authorization) { '' }
        let(:id) { talk.id }
        run_test!
      end
    end
  end

  path '/talks/{id}/rate' do
    post 'avaliar palestra' do
      tags 'Palestras'
      parameter name: :id, in: :path, type: :string
      security [token: []]

      parameter name: :rating, in: :body, schema: {
        type: :object,
        properties: {
          talk_id: { type: :number },
          score: { type: :number },
        }
      }

      response '200', 'palestra avaliada com sucesso' do
      end

      response '401', 'sem permissão para avaliar palestra' do
      end
    end
  end
end
