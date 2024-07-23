require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  context 'as staff' do
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:merch) { create(:merch, event: event) }
    let!(:reservations) { create_list(:reservation, 3, merch: merch, user: create(:attendee)) }

    before do 
      event.team.update users: [staff]
      @headers = { Authorization: authenticate(staff) }
    end

    describe 'GET /reservations' do
      it 'should list all reservations' do
        get "/events/#{event.slug}/reservations", headers: @headers
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to be_an_instance_of Array
        expect(data.length).to eq 3
      end
    end

    describe 'GET /reservations/1' do
      it 'should get a single reservation' do
        get "/events/#{event.slug}/reservations/#{reservations.first.id}", headers: @headers
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'merch'
      end
    end

    describe 'POST /reservations' do
      it 'should create a new reservation' do
        post "/events/#{event.slug}/reservations", headers: @headers, params: { merch_id: merch.id }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'merch'
      end
    end

    describe 'DELETE /reservations/1' do
      it 'should destroy a reservation' do
        delete "/events/#{event.slug}/reservations/#{reservations.first.id}", headers: @headers, params: { event_id: event.id }
        expect(response.status).to eq 200
      end
    end
  end

  context 'owns reservation' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }
    let!(:merch) { create(:merch, event: event) }
    let!(:reservations) { create_list(:reservation, 3, merch: create(:merch_with_event), user: create(:attendee)) }
    let!(:reservation) { create(:reservation, merch: merch, user: attendee) }

    before { @headers = { Authorization: authenticate(attendee) } }

    describe 'GET /reservations' do
      it 'should be able to list all reservations' do
        get "/events/#{event.slug}/reservations", headers: @headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET /reservations/1' do
      it 'should be able to get a single reservation' do
        get "/events/#{event.slug}/reservations/#{reservation.id}", headers: @headers, params: { event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'merch'
      end
    end

    describe 'POST /reservations' do
      it 'should be able to create a new reservation' do
        post "/events/#{event.slug}/reservations", headers: @headers, params: { merch_id: merch.id, user_id: attendee.id, event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'merch'
      end
    end

    describe 'DELETE /reservations/1' do
      it 'should be able to destroy own reservation' do
        delete "/events/#{event.slug}/reservations/#{reservation.id}", headers: @headers, params: { event_id: event.id }
        expect(response.status).to eq 200
      end
    end
  end
end
