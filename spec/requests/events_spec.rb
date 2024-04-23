require 'rails_helper'

def authenticate(user)
  post '/login', params: { email: user.email, password: user.password }
  Oj.load(response.body)['token']
end

RSpec.describe '/events', type: :request do
  context 'as an authenticated admin' do
    let!(:user) { create(:user) }
    let!(:admin) { create(:admin, user: user) }

    describe 'GET /event' do
      it 'should list all events' do
        token = authenticate user
        get '/events', headers: { Authorization: token }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'events'
      end
    end

    describe 'POST /event' do
      it 'should create event' do
        token = authenticate user
        post '/events', headers: { Authorization: token }, params: { event: { name: 'Semana da Computação 2024' } }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'event'
      end
    end

    describe 'PUT /event/1' do
      let!(:event) { create(:event) }
      it 'should update event' do
        token = authenticate user
        put "/events/#{event.id}", headers: { Authorization: token }, params: { event: { name: 'Semana da Química' } }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'event'
        expect(data['event']['name']).to eq 'Semana da Química'
      end
    end

    describe 'DELETE /event/1' do
      let!(:event) { create(:event) }
      it 'should delete event' do
        token = authenticate user
        delete "/events/#{event.id}", headers: { Authorization: token }
        data = Oj.load(response.body)

        expect(response.status).to eq 200
        expect(data).to have_key 'message'
      end
    end
  end

  context 'as an attendee' do
    let!(:user) { create(:user) }
    let!(:staff) { create(:staff, user: user) }

    describe 'GET /event' do
      it 'should list all events' do
        token = authenticate user
        get '/events', headers: { Authorization: token }
        expect(response.status).to eq 401
      end
    end

    describe 'POST /event' do
      it 'should create event' do
        token = authenticate user
        post '/events', headers: { Authorization: token }, params: { event: { name: 'Semana da Computação 2024' } }
        expect(response.status).to eq 401
      end
    end

    describe 'PUT /event/1' do
      let!(:event) { create(:event) }
      it 'should update event' do
        token = authenticate user
        put "/events/#{event.id}", headers: { Authorization: token }, params: { event: { name: 'Semana da Química' } }
        expect(response.status).to eq 401
      end
    end

    describe 'DELETE /event/1' do
      let!(:event) { create(:event) }
      it 'should delete event' do
        token = authenticate user
        delete "/events/#{event.id}", headers: { Authorization: token }
        expect(response.status).to eq 401
      end
    end
  end

  context 'unauthenticated' do
    let!(:event) { create(:event) }
    describe 'GET /event/1' do
      it 'should show a single event' do
        get "/events/#{event.id}"
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'event'
      end
    end
  end
end
