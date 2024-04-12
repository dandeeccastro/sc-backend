require 'rails_helper'

RSpec.describe "/events", type: :request do
  describe 'POST #create' do
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
end
