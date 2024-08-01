RSpec.describe '/talks', type: :request do
  context "Attendee" do
    let!(:user) { create(:attendee) }
    let!(:event) { create(:event) }
    let!(:talk) { create(:talk_with_event, event: event) }

    describe 'GET /show' do
      it 'renders a successful response' do
        token = authenticate user
        get "/talks/#{talk.id}", headers: { Authorization: token }
          expect(response).to be_successful
      end
    end

  end

  context 'Staff' do
    let!(:user) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:talk) { create(:talk, event: event, location: create(:location), speaker: create(:speaker, event: event), type: create(:type), categories: create_list(:category, 3, event: event)) }

    before { event.team.update users: [user] }

    describe 'PUT /update' do
      it 'should update talk' do
        token = authenticate user
        put "/talks/#{talk.id}", headers: { Authorization: token }, params: {
          title: 'Novo nome da Palestra',
        }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data['title']).to eq 'Novo nome da Palestra'
      end
    end
  end

  context 'Admin' do
    let!(:event) { create(:event) }
    let!(:location) { create(:location) }
    let!(:user) { create(:admin) }
    let!(:type) { create(:type) }
    let!(:speaker) { create(:speaker, event: event) }
    let!(:categories) { create_list(:category, 3, event: event) }
    let!(:talk) { create(:talk, event: event, location: location, speaker: speaker, type: type, categories: categories) }

    describe 'POST /create' do
      it 'should create a talk' do
        token = authenticate user
        post '/talks', headers: { Authorization: token },
          params: {
            title: 'Palestra exemplo',
            description: 'Um exemplo de palestra',
            start_date: event.start_date + 1.hour,
            end_date: event.start_date + 2.hour,
            vacancy_limit: 50,
            event_id: event.id,
            location_id: location.id,
            type_id: type.id,
            speaker_id: speaker.id,
            category_ids: categories.map(&:id)
          }

        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'title'
      end
    end

    describe 'PUT /update' do
      it 'should update talk' do
        token = authenticate user
        put "/talks/#{talk.id}", headers: { Authorization: token }, params: {
          title: 'Novo nome da Palestra',
        }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data['title']).to eq 'Novo nome da Palestra'
      end
    end
  end


end
