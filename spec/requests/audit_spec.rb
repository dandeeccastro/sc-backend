RSpec.describe "Audits", type: :request do
  context 'as an admin' do
    let!(:admin) { create(:admin) }
    let!(:event) { create(:event) }

    before do
      @headers = { Authorization: authenticate(admin) }
      AuditLogger.log(event, 'Creating inicial log message')
    end

    describe 'GET /seach' do
      it 'should return todays logs' do
        get "/events/#{event.slug}/audit", headers: @headers, params: { date: DateTime.now }
        expect(response.body).to include('Creating inicial log message')
      end

      it 'should fail to get tomorrow logs' do
        get "/events/#{event.slug}/audit", headers: @headers, params: { date: 1.day.from_now }
        data = Oj.load(response.body)

        expect(data).to be_an_instance_of(Hash)
        expect(data['message']).to eq("Log não encontrado para o dia #{1.day.from_now}!")
      end
    end
  end

  context 'as regular user' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }

    describe 'GET /seach' do
      it 'should return todays logs' do
        get "/events/#{event.slug}/audit", headers: { Authorization: authenticate(attendee)}, params: { date: DateTime.now }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
