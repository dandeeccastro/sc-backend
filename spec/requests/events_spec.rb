require 'rails_helper'

RSpec.describe '/events', type: :request do
  context 'as an authenticated admin' do
    let!(:user) { create(:admin) }
    let!(:events) { create_list(:event, 3) }

    describe 'GET /event' do
      it 'should list all events' do
        token = authenticate user
        get '/events', headers: { Authorization: token }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to be_an_instance_of Array
        expect(data.length).to eq 3
      end
    end

    describe 'POST /event' do
      it 'should create event' do
        token = authenticate user
        post '/events', headers: { Authorization: token }, params: { event: { name: 'Semana da Computação 2024' } }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'name'
      end
    end

    describe 'PUT /event/1' do
      let!(:event) { create(:event) }
      it 'should update event' do
        token = authenticate user
        put "/events/#{event.id}", headers: { Authorization: token }, params: { event: { name: 'Semana da Química' } }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'name'
        expect(data['name']).to eq 'Semana da Química'
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
    let!(:attendee) { create(:attendee) }

    describe 'GET /event' do
      it 'should list all events' do
        token = authenticate attendee
        get '/events', headers: { Authorization: token }
        expect(response.status).to eq 401
      end
    end

    describe 'POST /event' do
      it 'should create event' do
        token = authenticate attendee
        post '/events', headers: { Authorization: token }, params: { event: { name: 'Semana da Computação 2024' } }
        expect(response.status).to eq 401
      end
    end

    describe 'PUT /event/1' do
      let!(:event) { create(:event) }
      it 'should update event' do
        token = authenticate attendee
        put "/events/#{event.id}", headers: { Authorization: token }, params: { event: { name: 'Semana da Química' } }
        expect(response.status).to eq 401
      end
    end

    describe 'DELETE /event/1' do
      let!(:event) { create(:event) }
      it 'should delete event' do
        token = authenticate attendee
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
        expect(data).to have_key 'name'
      end
    end
  end
end
