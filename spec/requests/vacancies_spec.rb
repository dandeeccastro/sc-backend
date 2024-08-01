RSpec.describe '/vacancies', type: :request do
  context 'as attendee' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }

    let!(:full_talk) { create(:talk_with_event, event: event, vacancy_limit: 1)}
    let!(:vacancy_full_talk) { create(:vacancy_with_user, talk: full_talk )}

    let!(:talk) { create(:talk_with_event,event: event) }
    let!(:vacancy) { create(:vacancy, user: attendee, talk: talk)}

    let!(:free_talk) { create(:talk_with_event, event: event) }

    let!(:other_event) { create(:event, registration_start_date: 1.hour.from_now) }
    let!(:other_talk) { create(:talk_with_event, event: other_event) }

    before do 
      @headers = { Authorization: authenticate(attendee) } 
    end

    describe 'GET /vacancies/me' do
      it 'should show user vacancies' do
        get '/vacancies/me', headers: @headers, params: { event_slug: event.slug }
        data = Oj.load response.body

        expect(data).to be_an_instance_of(Hash)
        expect(data.values.flatten.length).to eq(1)
      end
    end

    describe 'POST /participate' do
      it 'should create vacancy on free talk' do
        post "/participate", headers: @headers, params: { talk_ids: [free_talk.id], event_slug: event.slug }
        data = Oj.load response.body

        expect(data).to be_an_instance_of(Hash)
        expect(data['confirmed'].length).to eq(1)
        expect(data['denied'].length).to eq(0)
      end

      it 'should fail to create vacancy on full talk' do
        post "/participate", headers: @headers, params: { talk_ids: [full_talk.id], event_slug: event.slug }
        data = Oj.load response.body

        expect(data).to be_an_instance_of(Hash)
        expect(data['confirmed'].length).to eq(0)
        expect(data['denied'].length).to eq(1)
      end

      it 'should fail to create vacancy on talk' do
        post "/participate", headers: @headers, params: { talk_ids: [other_talk.id], event_slug: other_event.slug }
        data = Oj.load response.body

        expect(response).to have_http_status(:unprocessable_entity)
        expect(data).to be_an_instance_of(Hash)
        expect(data['message']).to eq('Inscrições ainda não foram abertas!')
      end
    end
  end

  context 'as staff member' do
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event, registration_start_date: 2.hours.ago, start_date: 2.hours.ago) }

    let!(:current_talk) { create(:talk_with_event, event: event, start_date: DateTime.now, end_date: 1.hour.from_now) }
    let!(:vacancies) { create_list(:vacancy_with_user, 3, talk: current_talk) }

    let!(:later_talk) { create(:talk_with_event, event: event, start_date: 2.hour.ago, end_date: 1.hour.ago) }
    let!(:other_vacancy) { create(:vacancy_with_user, talk: later_talk) }

    before do
      event.team.update users: [staff]
      @headers = { Authorization: authenticate(staff) }
    end
    
    describe 'POST /validate' do
      it 'should mark presence for users in current talk' do
        presence = [ vacancies.first.user.id, vacancies.second.user.id ]
        absence = [ vacancies.last.user.id ]

        post "/validate", headers: @headers, params: { talk_id: current_talk.id, presence: presence, absence: absence, event_slug: event.slug }

        data = Oj.load(response.body)
        expect(response).to have_http_status(:ok)
        expect(data['message']).to eq('Presenças marcadas!')
      end

      it 'should fail to mark presence on later talk' do
        presence = [ other_vacancy.user.id ]

        post "/validate", headers: @headers, params: { talk_id: later_talk.id, presence: presence, absence: [], event_slug: event.slug }

        data = Oj.load(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(data['message']).to eq('Proibído marcar presença de palestra que ainda não começou!')
      end
    end
  end
end
