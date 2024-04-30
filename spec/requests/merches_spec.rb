require 'rails_helper'

def authenticate(user)
  post '/login', params: { email: user.email, password: user.password }
  Oj.load(response.body)['token']
end

RSpec.describe '/merches', type: :request do
  context 'as staff leader' do
    let!(:staff) { create(:staff_leader) }
    let!(:event) { create(:event) }
    let!(:team) { create(:team, event: event, staffs: [staff]) }
    let!(:merches) { create_list(:merch, 3) }

    before { @token = authenticate staff.user }

    describe 'POST /merches' do
      it 'should create a new merch' do
        post '/merches', headers: { Authorization: @token }, params: { name: 'Example Merch', price: 9999, event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'price'
        expect(data['name']).to eq 'Example Merch'
      end
    end

    describe 'PUT /merches/1' do
      it 'should update existing merch' do
        put '/merches/1', headers: { Authorization: @token }, params: { price: 1999, event_id: event.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'price'
        expect(data['price']).to eq 1999
      end
    end
  end

  context 'unauthorized' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }
    let!(:merches) { create_list(:merch, 3) }

    before { @token = authenticate attendee.user }

    describe 'GET /merches' do
      it 'should get all merches' do
        get '/merches', headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to be_an_instance_of Array
      end
    end

    describe 'GET /merches/1' do
      it 'should show a single merch' do
        get "/merches/#{merches.first.id}", headers: { Authorization: @token }
        data = Oj.load response.body

        expect(data).to have_key 'name'
        expect(data).to have_key 'price'
      end
    end
  end
end
