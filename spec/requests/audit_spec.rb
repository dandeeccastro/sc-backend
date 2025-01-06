require 'swagger_helper'

describe 'Audit API' do
  before do
    @event = create(:event)
    AuditLogger.log(@event, 'log de teste')
  end

  path '/events/{slug}/audit' do
    get 'listar logs de auditoria' do
      tags 'Auditoria'
      consumes 'application/json'
      produces 'application/json'
      security [token: []]
      parameter name: :slug, in: :path, type: :string
      parameter name: :date, in: :query, type: :string

      response '200', 'listagem de logs com sucesso' do
        let(:Authorization) { authenticate(create(:admin)) }
        let(:date) { DateTime.now.to_s.split('T').first }
        let(:slug) { @event.slug }
        run_test!
      end

      response '401', 'sem permissão para listar' do
        let(:Authorization) { authenticate(create(:attendee)) }
        let(:date) { DateTime.now.to_s.split('T').first }
        let(:slug) { @event.slug }
        run_test!
      end

      response '404', 'log não encontrado' do
        let(:slug) { @event.slug }
        let(:Authorization) { authenticate(create(:admin)) }
        let(:date) { 1.day.from_now.to_s }
        run_test!
      end
    end
  end
end
