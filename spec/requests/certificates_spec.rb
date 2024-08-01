RSpec.describe "Certificates", type: :request do
  context 'attendee with certificate eligibility' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }
    let!(:talks) { create_list(:talk_with_event, 3, event: event) }
    let!(:vacancies) do 
      arr = []
      3.times { |i| arr << create(:confirmed_presence, user: attendee, talk: talks[i])}
      arr
    end

    before { @headers = { Authorization: authenticate(attendee) } }

    describe 'GET /list' do
      it 'should list certificates from user' do
        get '/certificates', headers: @headers, params: { emit_from: 'myself' }
        data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of(Array)
        expect(data.length).to eq(4)
      end
    end
  end

  context 'staff member from event' do
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:talk) { create(:talk_with_event, event: event) }
    let!(:vacancies) { create(:confirmed_presence, user: create(:attendee), talk: talk )}

    before do 
      event.team.update users: [staff]
      @headers = { Authorization: authenticate(staff) } 
    end

    describe 'POST /emit' do
      it 'should emit certificates for users' do
        post '/certificates', headers: @headers, params: { event_slug: event.slug, emit_from: 'event' }
        data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of(Hash)
        expect(data['message']).to eq('Certificados emitidos com sucesso!')
      end

      it 'should emit certificates for one user' do
        post '/certificates', headers: @headers, params: { event_slug: event.slug, emit_from: 'user', user_id: vacancies.user.id }
        data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of(Hash)
        expect(data['message']).to eq('Certificados emitidos com sucesso!')
      end
    end
  end
end
