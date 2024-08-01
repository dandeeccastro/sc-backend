require 'rails_helper'

RSpec.describe '/teams', type: :request do
  context 'as an admin' do
    let!(:admin) { create(:admin) }
    let!(:event) { create(:event) }
    let!(:staffs) { create_list(:staff, 3) }

    before { @token = authenticate admin }

    describe 'GET /teams' do
      it 'should show all teams' do
        get '/teams', headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response).to be_successful
        expect(data).to be_an_instance_of Array
      end
    end

    describe 'GET /teams/slug' do
      it 'should show a team from an event' do
        get "/teams/#{event.slug}", headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response).to be_successful
        expect(data).to have_key 'users'
      end
    end

    describe 'POST /team' do
      it 'should create a new team' do
        post '/teams', headers: { Authorization: @token }, params: { user_ids: staffs.map(&:id) }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'users'
      end
    end

    describe 'PUT /team/1' do
      it 'should update an existing team' do
        put "/teams/#{event.team.id}", headers: { Authorization: @token }, params: { slug: event.slug, user_ids: staffs.map(&:id) }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'users'
        expect(data['users'].length).to eq 3
      end
    end

    describe 'DELETE /team/1' do
      it 'should delete a team' do
        delete "/teams/#{event.team.id}", headers: { Authorization: @token }
        data = Oj.load response.body
        expect(response.status).to eq 200
        expect(data).to have_key 'message'
      end
    end
  end

  context 'as a staff leader' do
    let!(:event) { create(:event) }
    let!(:staff) { create(:staff_leader) }
    let!(:staffs) { create_list(:staff, 3) }

    before do 
      event.team.update users: [staff]
      @token = authenticate staff 
    end

    describe 'GET /teams' do
      it 'should fail to show all teams' do
        get '/teams', headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end

    describe 'GET /teams/slug' do
      it 'should show a given team' do
        get "/teams/#{event.slug}", headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response).to have_http_status(:ok)
        expect(data).to have_key 'users'
      end
    end

    describe 'POST /team' do
      it 'should create a new team' do
        post '/teams', headers: { Authorization: @token }, params: { user_ids: staffs.map(&:id) }
        expect(response.status).to eq 401
      end
    end

    describe 'PUT /team/1' do
      it 'should update an existing team' do
        put "/teams/#{event.team.id}", headers: { Authorization: @token }, params: { slug: event.slug, user_ids: staffs.map(&:id) }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'users'
      end
    end

    describe 'DELETE /team/1' do
      it 'should delete a team' do
        delete "/teams/#{event.team.id}", headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end
  end

  context 'unauthenticated' do
    let!(:staff) { create(:staff) }
    let!(:event) { create(:event) }
    let!(:staffs) { create_list(:staff, 3) }

    before { @token = authenticate staff }

    describe 'GET /teams' do
      it 'should show all teams' do
        get '/teams', headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end

    describe 'GET /teams/slug' do
      it 'should show a given team' do
        get "/teams/#{event.slug}", headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end

    describe 'POST /team' do
      it 'should create a new team' do
        post '/teams', headers: { Authorization: @token }, params: { user_ids: staffs.map(&:id) }
        expect(response.status).to eq 401
      end
    end

    describe 'PUT /team/1' do
      it 'should update an existing team' do
        put "/teams/#{event.team.id}", headers: { Authorization: @token }, params: { slug: event.slug, user_ids: staffs.map(&:id) }
        expect(response.status).to eq 401
      end
    end

    describe 'DELETE /team/1' do
      it 'should delete a team' do
        delete "/teams/#{event.team.id}", headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end
  end
end
