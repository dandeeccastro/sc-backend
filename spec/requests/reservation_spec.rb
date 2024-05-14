require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  context 'as staff' do
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:team) { create(:team, event: event, users: [staff]) }
    let!(:merch) { create(:merch, event: event) }
    let!(:reservations) { create_list(:reservation, 3) }

    before { @token = authenticate staff }

    describe 'GET /reservations' do
      it 'should list all reservations' do
        get '/reservations', headers: { Authorization: @token }, params: { event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to be_an_instance_of Array
        expect(data.length).to eq 3
      end
    end

    describe 'GET /reservations/1' do
      it 'should get a single reservation' do
        get "/reservations/#{reservations.first.id}", headers: { Authorization: @token }, params: { event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'merch'
      end
    end

    describe 'POST /reservations' do
      it 'should create a new reservation' do
        post '/reservations', headers: { Authorization: @token }, params: { merch_id: merch.id, user_id: staff.id, event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'merch'
      end
    end

    describe 'DELETE /reservations/1' do
      it 'should destroy a reservation' do
        delete "/reservations/#{reservations.first.id}", headers: { Authorization: @token }, params: { event_id: event.id }
        expect(response.status).to eq 204
      end
    end
  end

  context 'owns reservation' do
    let!(:attendee) { create(:attendee) }
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:team) { create(:team, event: event, users: [staff]) }
    let!(:merch) { create(:merch, event: event) }
    let!(:reservations) { create_list(:reservation, 3) }
    let!(:reservation) { create(:reservation, merch: merch, user: attendee) }

    before { @token = authenticate attendee }

    describe 'GET /reservations' do
      it 'should be able to list all reservations' do
        get '/reservations', headers: { Authorization: @token }, params: { event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to be_an_instance_of Array
        expect(data.length).to eq 4
      end
    end

    describe 'GET /reservations/1' do
      it 'should be able to get a single reservation' do
        get "/reservations/#{reservation.id}", headers: { Authorization: @token }, params: { event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'merch'
      end
    end

    describe 'POST /reservations' do
      it 'should be able to create a new reservation' do
        post '/reservations', headers: { Authorization: @token }, params: { merch_id: merch.id, user_id: attendee.id, event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'merch'
      end
    end

    describe 'DELETE /reservations/1' do
      it 'should be able to destroy own reservation' do
        delete "/reservations/#{reservation.id}", headers: { Authorization: @token }, params: { event_id: event.id }
        expect(response.status).to eq 204
      end
    end
  end
end
