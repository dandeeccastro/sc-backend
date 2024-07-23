RSpec.describe "/notifications", type: :request do
  context 'as a staff member' do
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:talk) { create(:talk, event: event) }
    let!(:notifications) { create_list(:notification, 3, user: staff, event: event)}

    before do
      event.team.update users: [staff]
      @headers = { Authorization: authenticate(staff) }
    end

    describe 'POST /notifications' do
      it 'should create a new event notification' do
        post "/events/#{event.slug}/notifications", headers: @headers, params: { title: 'Titulo', description: 'Notificação teste', event_id: event.id }
        data = Oj.load response.body
        expect(response.status).to eq 201
        expect(data).to have_key('title')
        expect(data['talk_id']).to eq(nil)
      end

      it 'should create a new talk notification' do
        post "/events/#{event.slug}/notifications", headers: @headers, params: { title: 'Titulo', description: 'Notificação teste', event_id: event.id, talk_id: talk.id }
        data = Oj.load response.body
        expect(response.status).to eq 201
        expect(data).to have_key('title')
        expect(data['talk']['id']).to eq(talk.id)
      end
    end

    describe 'PUT /notifications/1' do
      it 'should delete a notification' do
        put "/events/#{event.slug}/notifications/#{notifications.first.id}", headers: @headers, params: { description: 'Notificação atualizada' }
        data = Oj.load response.body
        expect(response.status).to eq 200
        expect(data['description']).to eq('Notificação atualizada')
      end
    end

    describe 'DELETE /notifications/1' do
      it 'should delete a notification' do
        delete "/events/#{event.slug}/notifications/#{notifications.first.id}", headers: @headers
        expect(response.status).to eq 200
      end
    end
  end

  context 'as an attendee' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }
    let!(:notifications) { create_list(:notification_with_user, 3, event: event)}

    before do
      @headers = { Authorization: authenticate(attendee) }
    end

    describe 'GET /notifications' do
      it 'should list notifications' do
        get "/events/#{event.slug}/notifications", headers: @headers, params: { event_id: event.id }
        data = Oj.load response.body
        expect(response.status).to eq 200
        expect(data).to be_an_instance_of(Array)
      end
    end
  end
end
