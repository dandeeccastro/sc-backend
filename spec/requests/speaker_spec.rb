require 'swagger_helper'

describe 'Speaker API' do
  path '/speaker' do
    post 'criar palestrante' do
      tags 'Palestrante'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :speaker, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          bio: { type: :string },
          email: { type: :string },
          event_id: { type: :integer },
          image: { type: :string, format: :binary },
        },
        required: %i[name email event_id]
      }

      response '201', 'palestrante criado com sucesso' do
        let(:Authorization) { authenticate(create(:admin)) }
        let(:event) { create(:event) }
        let(:speaker) { create(:speaker, event:) }
        run_test!
      end

      response '401', 'sem permissão para criar palestrante' do
        let(:Authorization) { authenticate(create(:attendee)) }
        let(:event) { create(:event) }
        let(:speaker) { create(:speaker, event:) }
        run_test!
      end

      response '422', 'dados incorretos' do
        let(:Authorization) { authenticate(create(:admin)) }
        let(:event) { create(:event) }
        let(:speaker) { { event_id: event.id } }
        run_test!
      end
    end
  end

  path '/speaker/{id}' do
    put 'atualizar palestrante' do
      tags 'Palestrante'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string

      parameter name: :speaker, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          bio: { type: :string },
          email: { type: :string },
          event_id: { type: :integer },
          image: { type: :string, format: :binary },
        }
      }

      response '200', 'palestrante atualizado com sucesso' do
        let(:Authorization) { authenticate(create(:admin)) }
        let(:event) { create(:event) }
        let(:existing_speaker) { create(:speaker, event:) }
        let(:id) { existing_speaker.id }
        let(:speaker) { { name: 'Novo nome', event_id: event.id } }
        run_test!
      end

      response '401', 'sem permissão para atualizar palestrante' do
        let(:Authorization) { authenticate(create(:attendee)) }
        let(:event) { create(:event) }
        let(:existing_speaker) { create(:speaker, event:) }
        let(:id) { existing_speaker.id }
        let(:speaker) { { name: 'Novo nome', event_id: event.id } }
        run_test!
      end
    end

    delete 'remover palestrante' do
      tags 'Palestrante'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string
      parameter name: :speaker, in: :body, schema: {
        type: :object,
        properties: {
          event_id: { type: :string }
        }
      }

      response '200', 'palestrante deletado com sucesso' do
        let(:Authorization) { authenticate(create(:admin)) }
        let(:event) { create(:event) }
        let(:speaker) { { event_id: event.id } }
        let(:bonk) { create(:speaker, event:) }
        let(:id) { bonk.id }
        run_test!
      end

      response '401', 'sem permissão para deletar palestrante' do
        let(:Authorization) { authenticate(create(:attendee)) }
        let(:event) { create(:event) }
        let(:event_id) { event.id }
        let(:speaker) { { event_id: event.id } }
        let(:bonk) { create(:speaker, event:) }
        let(:id) { bonk.id }
        run_test!
      end
    end
  end

  path '/events/{slug}/speakers' do
    get 'listar palestrantes do evento' do
      tags 'Palestrante'
      security [token: []]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :slug, in: :path, type: :string

      response '200', 'lista palestrantes cadastrados no evento' do
        let(:Authorization) { authenticate(create(:attendee)) }
        let(:event) { create(:event) }
        let(:slug) { event.slug }
        let(:speakers) { create_list(:speaker, event: event)}
        run_test!
      end
    end
  end
end
# RSpec.describe "Speakers", type: :request do
#   context 'attendee' do
#     let!(:attendee) { create(:attendee) }
#     let!(:event) { create(:event) }
#     let!(:speakers) { create_list(:speaker, 3, event: event) }
#     let!(:other_speakers) { create_list(:speaker_with_event, 3) }
#
#     before { @headers = { Authorization: authenticate(attendee) } }
#
#     describe 'GET /events/slug/speaker' do
#       it 'should list speakers in event' do
#         get "/events/#{event.slug}/speakers", headers: @headers
#         data = Oj.load(response.body)
#
#         expect(data).to be_an_instance_of(Array)
#         expect(data.length).to eq(3)
#       end
#     end
#   end
#
#   context 'staff from event' do
#     let!(:staff) { create(:staff) }
#     let!(:event) { create(:event) }
#     let!(:speaker) { create(:speaker, event: event) }
#
#     before do
#       event.team.update users: [staff]
#       @headers = { Authorization: authenticate(staff) }
#     end
#
#     describe 'POST /speaker' do
#       it 'should create speaker' do
#         post '/speaker', headers: @headers, params: { event_slug: event.slug, name: 'Nome', bio: 'Bio', email: 'testing@email.com' }
#         data = Oj.load(response.body)
#
#         expect(response).to have_http_status(:created)
#         expect(data).to be_an_instance_of(Hash)
#         expect(data['name']).to eq('Nome')
#       end
#     end
#
#     describe 'PUT /speaker/1' do
#       it 'should update speaker' do
#         put "/speaker/#{speaker.id}", headers: @headers, params: { event_slug: event.slug, name: 'Nome Atualizado'}
#           data = Oj.load(response.body)
#
#         expect(response).to have_http_status(:ok)
#         expect(data).to be_an_instance_of(Hash)
#         expect(data['name']).to eq('Nome Atualizado')
#       end
#     end
#
#     describe 'DELETE /speaker/1' do
#       it 'should delete speaker' do
#         delete "/speaker/#{speaker.id}", headers: @headers, params: { event_slug: event.slug }
#           data = Oj.load(response.body)
#
#         expect(response).to have_http_status(:ok)
#         expect(data).to be_an_instance_of(Hash)
#         expect(data).to have_key('message')
#       end
#     end
#   end
# end
