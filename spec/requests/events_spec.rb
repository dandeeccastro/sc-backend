require 'rails_helper'

RSpec.describe '/events', type: :request do
  context 'as an authenticated admin' do
    let!(:user) { create(:admin) }
    let!(:events) { create_list(:event, 3) }

    before { @headers = { Authorization: authenticate(user) } }

    describe 'GET /event' do
      it 'should list all events' do
        get '/events', headers: @headers
        data = Oj.load response.body

        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of Array
        expect(data.length).to eq 3
      end
    end

    describe 'POST /event' do
      it 'should create event' do
        post '/events', headers: @headers, params: {
          name: 'Test event',
          start_date: DateTime.current,
          end_date: 1.week.from_now,
          registration_start_date: DateTime.current,
        }
        data = Oj.load response.body

        expect(response).to have_http_status(:created)
        expect(data).to have_key 'name'
      end
    end

    describe 'PUT /event/1' do
      let!(:event) { create(:event) }
      it 'should update event' do
        put "/events/#{event.id}", headers: @headers, params: { name: 'Semana da Química' }
        data = Oj.load response.body

        expect(response).to have_http_status(:ok)
        expect(data).to have_key 'name'
        expect(data['name']).to eq 'Semana da Química'
      end
    end

    describe 'DELETE /event/1' do
      let!(:event) { create(:event) }
      it 'should delete event' do
        delete "/events/#{event.id}", headers: @headers
        data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data).to have_key 'message'
      end
    end
  end

  context 'as an attendee' do
    let!(:attendee) { create(:attendee) }

    describe 'GET /event' do
      it 'should list all events' do
        get '/events', headers: @headers
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /event' do
      it 'should create event' do
        post '/events', headers: @headers, params: { name: 'Semana da Computação 2024' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT /event/1' do
      let!(:event) { create(:event) }
      it 'should update event' do
        put "/events/#{event.id}", headers: @headers, params: { name: 'Semana da Química' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE /event/1' do
      let!(:event) { create(:event) }
      it 'should delete event' do
        delete "/events/#{event.id}", headers: @headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'unauthenticated' do
    let!(:event) { create(:event) }

    describe 'GET /event/1' do
      it 'should show a single event' do
        get "/events/#{event.slug}"
        data = Oj.load response.body

        expect(response).to have_http_status(:ok)
        expect(data).to have_key 'name'
      end
    end
  end
end
