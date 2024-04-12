require 'rails_helper'

def authenticate(user)
  post '/login', params: { email: user.email, password: user.password }
  Oj.load(response.body)['token']
end

RSpec.describe "/events", type: :request do
  describe 'GET /events' do
    let!(:user) { create(:user) }
    let!(:admin) { create(:admin, user: user) }
    let!(:events) { create_list(:event, 3) }

    it 'should list all events' do
      token = authenticate(user)

      get '/events', headers: { Authorization: token }
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data).to have_key 'events'
    end
  end

  describe 'GET /event/1' do
    let!(:event) { create(:event) }
    it 'should show a single event' do
      get "/events/#{event.id}"
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data).to have_key 'event'
    end
  end

  describe 'POST /events' do
    context 'authenticated admin' do
      let!(:user) { create(:user) }
      let!(:admin) { create(:admin, user: user) }

      it 'should create event' do
        post '/login', params: { email: user.email, password: user.password }
        token = Oj.load(response.body)['token']

        post '/events', headers: { Authorization: token }, params: { event: { name: 'Semana da Computação 2024' } }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'event'
      end
    end

    context 'authenticated attendee' do
      let!(:user) { create(:user) }
      let!(:attendee) { create(:attendee, user: user) }

      it 'should fail to create event' do
        post '/login', params: { email: user.email, password: user.password }
        token = Oj.load(response.body)['token']

        post '/events', headers: { Authorization: token }, params: { event: { name: 'Semana da Computação 2024' } }
        data = Oj.load response.body

        expect(response.status).to eq 401
        expect(data).to have_key 'errors'
      end
    end
  end

  describe 'PUT /event/1' do
    let!(:user) { create(:user) }
    let!(:admin) { create(:admin, user: user) }
    let!(:event) { create(:event) }

    it 'should update event' do
      post '/login', params: { email: user.email, password: user.password }
      token = Oj.load(response.body)['token']

      put "/events/#{event.id}", headers: { Authorization: token }, params: { event: { name: 'Semana da Química' } }
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data).to have_key 'event'
      expect(data['event']['name']).to eq 'Semana da Química'
    end
  end

  describe 'DELETE /events/1' do
    let!(:user) { create(:user) }
    let!(:admin) { create(:admin, user: user) }
    let!(:event) { create(:event) }

    it 'should delete event' do
      token = authenticate(user)
      delete "/events/#{event.id}", headers: { Authorization: token }

      data = Oj.load(response.body)

      expect(response.status).to eq 200
      expect(data).to have_key 'message'
    end
  end
end
