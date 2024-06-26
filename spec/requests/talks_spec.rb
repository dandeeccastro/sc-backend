require 'rails_helper'

def regular_admin_setup
  let!(:event) { create(:event) }
  let!(:location) { create(:location) }
  let!(:user) { create(:admin) }
end

def regular_staff_setup
  let!(:user) { create(:staff) }
  let!(:team) { create(:team, users: [user]) }
  let!(:event) { create(:event, team: team) }
  let!(:location) { create(:location) }
end

def regular_attendee_with_talk
  let!(:event) { create(:event) }
  let!(:location) { create(:location) }
  let!(:talk) { create(:talk, event: event, location: location) }
  let!(:user) { create(:attendee) }
end

RSpec.describe '/talks', type: :request do
  describe 'GET /show' do
    regular_attendee_with_talk
    it 'renders a successful response' do
      token = authenticate user
      get "/talks/#{talk.id}", headers: { Authorization: token }

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    regular_admin_setup
    it 'should create a talk' do
      token = authenticate user
      post '/talks', headers: { Authorization: token },
        params: {
          talk: {
            title: 'Palestra exemplo',
            description: 'Um exemplo de palestra',
            start_date: '2024-06-27 12:00',
            end_date: '2024-06-27 14:00',
            vacancy_limit: 50,
            event_id: event.id,
            location_id: location.id,
          }
        }

      data = Oj.load response.body

      expect(response.status).to eq 201
      expect(data).to have_key 'title'
    end
  end

  describe 'PUT /update' do
    context 'as admin' do
      regular_admin_setup
      let!(:talk) { create(:talk, event: event, location: location) }
      it 'should update talk' do
        token = authenticate user
        put "/talks/#{talk.id}", headers: { Authorization: token }, params: {
          talk: {
            title: 'Novo nome da Palestra',
            event_id: event.id
          }
        }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data['title']).to eq 'Novo nome da Palestra'
      end
    end

    context 'as staff' do
      regular_staff_setup
      let!(:talk) { create(:talk, event: event, location: location) }
      it 'should update talk' do
        token = authenticate user
        put "/talks/#{talk.id}", headers: { Authorization: token }, params: {
          talk: {
            title: 'Novo nome da Palestra',
            event_id: event.id
          }
        }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data['title']).to eq 'Novo nome da Palestra'
      end
    end
  end
end
