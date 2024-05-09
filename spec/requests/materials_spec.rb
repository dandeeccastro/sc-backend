require 'rails_helper'

RSpec.describe "/materials", type: :request do
  context 'as staff from event' do
    let!(:staff) { create(:staff) }
    let!(:team) { create(:team, users: [staff]) }
    let!(:event) { create(:event, team: team) }
    let!(:talk) { create(:talk, event: event) }
    let!(:materials) { create_list(:material, 3, talk: talk) }

    before { @token = authenticate staff }

    describe 'POST /materials' do
      it 'should add a new material to talk' do
        post '/materials', headers: { Authorization: @token }, params: { talk_id: talk.id, name: 'Material' }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'name'
      end
    end

    describe 'PUT /materials/1' do
      it 'should update an material from a talk' do
        put "/materials/#{materials.first.id}", headers: { Authorization: @token }, params: { name: 'Palestra com Material', talk_id: talk.id }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'name'
        expect(data['name']).to eq 'Palestra com Material'
      end
    end

    describe 'DELETE /materials/1' do
      it 'should delete a material from a talk' do
        delete "/materials/#{materials.first.id}", headers: { Authorization: @token }, params: { talk_id: talk.id }
        expect(response.status).to eq 204
      end
    end
  end

  context 'unauthenticated' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }
    let!(:team) { create(:team, event: event) }
    let!(:talk) { create(:talk, event: event) }
    let!(:materials) { create_list(:material, 3, talk: talk) }

    before { @token = authenticate attendee }

    describe 'POST /materials' do
      it 'should add a new material to talk' do
        post '/materials', headers: { Authorization: @token }, params: { talk_id: talk.id, name: 'Material' }
        expect(response.status).to eq 401
      end
    end

    describe 'PUT /materials/1' do
      it 'should update an material from a talk' do
        put "/materials/#{materials.first.id}", headers: { Authorization: @token }, params: { name: 'Palestra com Material', talk_id: talk.id }
        expect(response.status).to eq 401
      end
    end

    describe 'DELETE /materials/1' do
      it 'should delete a material from a talk' do
        delete "/materials/#{materials.first.id}", headers: { Authorization: @token }, params: { talk_id: talk.id }
        expect(response.status).to eq 401
      end
    end
  end
end
