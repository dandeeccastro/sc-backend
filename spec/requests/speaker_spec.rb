RSpec.describe "Speakers", type: :request do
  context 'attendee' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }
    let!(:speakers) { create_list(:speaker, 3, event: event) }
    let!(:other_speakers) { create_list(:speaker_with_event, 3) }

    before { @headers = { Authorization: authenticate(attendee) } }

    describe 'GET /events/slug/speaker' do
      it 'should list speakers in event' do
        get "/events/#{event.slug}/speakers", headers: @headers
        data = Oj.load(response.body)

        expect(data).to be_an_instance_of(Array)
        expect(data.length).to eq(3)
      end
    end
  end

  context 'staff from event' do
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:speaker) { create(:speaker, event: event) }

    before do
      event.team.update users: [staff]
      @headers = { Authorization: authenticate(staff) }
    end

    describe 'POST /speaker' do
      it 'should create speaker' do
        post '/speaker', headers: @headers, params: { event_slug: event.slug, name: 'Nome', bio: 'Bio', email: 'testing@email.com' }
        data = Oj.load(response.body)

        expect(response).to have_http_status(:created)
        expect(data).to be_an_instance_of(Hash)
        expect(data['name']).to eq('Nome')
      end
    end

    describe 'PUT /speaker/1' do
      it 'should update speaker' do
        put "/speaker/#{speaker.id}", headers: @headers, params: { event_slug: event.slug, name: 'Nome Atualizado'}
          data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of(Hash)
        expect(data['name']).to eq('Nome Atualizado')
      end
    end

    describe 'DELETE /speaker/1' do
      it 'should delete speaker' do
        delete "/speaker/#{speaker.id}", headers: @headers, params: { event_slug: event.slug }
          data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of(Hash)
        expect(data).to have_key('message')
      end
    end
  end
end
