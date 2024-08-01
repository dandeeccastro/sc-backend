require 'rails_helper'

RSpec.describe "Merches", type: :request do
  context 'as staff leader' do
    let!(:staff) { create(:staff_leader) }
    let!(:event) { create(:event) }
    let!(:merches) { create_list(:merch, 3, event: event) }

    before do 
      event.team.update(users: [staff])
      @headers = { Authorization: authenticate(staff) }
    end

    describe 'GET /merches' do
      it 'should get all merches' do
        get "/events/#{event.slug}/merches", headers: @headers
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to be_an_instance_of Array
      end
    end

    describe 'GET /merches/1' do
      it 'should show a single merch' do
        get "/events/#{event.slug}/merches/#{merches.first.id}", headers: @headers
        data = Oj.load response.body

        expect(data).to have_key 'name'
        expect(data).to have_key 'price'
      end
    end

    describe 'POST /merches' do
      it 'should create a new merch' do
        post "/events/#{event.slug}/merches", headers: @headers, params: { name: 'Example Merch', price: 9999, event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'price'
        expect(data['name']).to eq 'Example Merch'
      end
    end

    describe 'PUT /merches/1' do
      it 'should update existing merch' do
        put "/events/#{event.slug}/merches/#{merches[0].id}", headers: @headers, params: { price: 1999, event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'price'
        expect(data['price']).to eq 1999
      end
    end

    describe 'DELETE /merches/1' do
      it 'should delete a merch' do
        delete "/events/#{event.slug}/merches/#{merches[0].id}", headers: @headers, params: { event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'message'
      end
    end
  end

  context 'unauthorized' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }
    let!(:team) { create(:team, event: event) }
    let!(:merches) { create_list(:merch, 3, event: event) }

    before { @token = authenticate attendee }

    describe 'GET /merches' do
      it 'should get all merches' do
        get "/events/#{event.slug}/merches", headers: @headers
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to be_an_instance_of Array
      end
    end

    describe 'GET /merches/1' do
      it 'should show a single merch' do
        get "/events/#{event.slug}/merches/#{merches.first.id}", headers: @headers
        data = Oj.load response.body

        expect(data).to have_key 'name'
        expect(data).to have_key 'price'
      end
    end

    describe 'POST /merches' do
      it 'should not authorize to create a new merch' do
        post "/events/#{event.slug}/merches", headers: @headers, params: { name: 'Example Merch', price: 9999, event_id: event.id }

        expect(response.status).to eq 401
      end
    end

    describe 'PUT /merches/1' do
      it 'should update existing merch' do
        put "/events/#{event.slug}/merches/#{merches[0].id}", headers: @headers, params: { price: 1999, event_id: event.id }

        expect(response.status).to eq 401
      end
    end

    describe 'DELETE /merches/1' do
      it 'should delete a merch' do
        delete "/events/#{event.slug}/merches/#{merches[0].id}", headers: @headers, params: { event_id: event.id }
        expect(response.status).to eq 401
      end
    end
  end
end
