require 'rails_helper'

RSpec.describe "/notifications", type: :request do
  context 'as a staff member' do
    let!(:staff) { create(:staff) }
    let!(:team) { create(:team, users: [staff]) }
    let!(:event) { create(:event, team: team) }
    let!(:notifications) { create_list(:notification, 3, user: staff, event: event)}
    describe 'POST /notifications' do
      it 'should create a new notification' do
        token = authenticate staff
        post '/notifications', headers: { Authorization: token }, params: { description: 'Notificação teste', event_id: event.id, user_id: staff.id }
        data = Oj.load response.body
        expect(response.status).to eq 201
      end
    end

    describe 'DELETE /notifications/1' do
      it 'should delete a notification' do
        token = authenticate staff
        delete '/notifications/1', headers: { Authorization: token }, params: { description: 'Notificação teste', event_id: event.id, user_id: staff.id }
        data = Oj.load response.body
        expect(response.status).to eq 200
      end
    end
  end

  context 'as an attendee' do
    let!(:user) { create(:user) }
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:team) { create(:team, event: event, users: [staff]) }
    describe 'GET /notifications' do
      it 'should list notifications' do
        token = authenticate user
        get '/notifications', headers: { Authorization: token }, params: { event_id: event.id }
        data = Oj.load response.body
        expect(response.status).to eq 200
      end
    end
  end
end
