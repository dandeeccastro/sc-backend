require 'rails_helper'

RSpec.describe '/vacancies', type: :request do
  context 'as staff' do
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:team) { create(:team, event: event, users: [staff]) }
    let!(:talk) { create(:talk, event: event) }
    let!(:vacancies) { create_list(:vacancy, 3, talk: talk) }

    before { @token = authenticate staff }

    describe 'GET /vacancies' do
      it 'should list all vacancies ' do
        get '/vacancies', headers: { Authorization: @token }, params: { talk_id: talk.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to be_an_instance_of Array
        expect(data.length).to eq 3
      end
    end

    describe 'GET /vacancies/1' do
      it 'should show a single vacancy' do
        get "/vacancies/#{vacancies.first.id}", headers: { Authorization: @token }, params: { talk_id: talk.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'talk'
      end
    end

    describe 'PUT /vacancies/1' do
      it 'should validate a presence on a vacancy' do
        put "/vacancies/#{vacancies.first.id}", headers: { Authorization: @token }, params: { talk_id: talk.id, presence: true }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'presence'
        expect(data['presence']).to eq true
      end
    end
  end

  context 'as attendee' do
    let!(:event) { create(:event) }
    let!(:talk) { create(:talk, event: event) }
    let!(:vacancies) { create_list(:vacancy, 3, talk: talk) }
    let!(:attendee) { create(:attendee) }

    before { @token = authenticate attendee }

    describe 'POST /vacancies' do
      it 'should create vacancy' do
        post '/vacancies', headers: { Authorization: @token }, params: { talk_id: talk.id, user_id: attendee.id }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'presence'
      end
    end

    describe 'DELETE /vacancies/1' do
      it 'should remove vacancy' do
        delete "/vacancies/#{vacancies.first.id}", headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response.status).to eq 204
      end
    end
  end
end
