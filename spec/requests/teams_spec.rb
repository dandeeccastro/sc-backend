require 'rails_helper'

def authenticate(user)
  post '/login', params: { email: user.email, password: user.password }
  Oj.load(response.body)['token']
end

RSpec.describe '/teams', type: :request do
  context 'as an admin' do
    let!(:admin) { create(:admin) }
    let!(:team) { create(:team) }
    let!(:staffs) { create_list(:staff, 3) }

    before do @token = authenticate admin.user end

    describe 'GET /teams' do
      it 'should show all teams' do
        get '/teams', headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response).to be_successful
        expect(data).to be_an_instance_of Array
      end
    end

    describe 'GET /teams/1' do
      it 'should show a given team' do
        get "/teams/#{team.id}", headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response).to be_successful
        expect(data).to have_key 'staffs'
      end
    end

    describe 'POST /team' do
      it 'should create a new team' do
        post '/teams', headers: { Authorization: @token }, params: { staff_ids: staffs.map(&:id) }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'staffs'
      end
    end

    describe 'PUT /team/1' do
      it 'should update an existing team' do
        put "/teams/#{team.id}", headers: { Authorization: @token }, params: { staff_ids: staffs.map(&:id) }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'staffs'
        expect(data['staffs'].length).to eq 3
      end
    end

    describe 'DELETE /team/1' do
      it 'should delete a team' do
        delete "/teams/#{team.id}", headers: { Authorization: @token }
        data = Oj.load response.body
        expect(response.status).to eq 200
        expect(data).to have_key 'message'
      end
    end
  end

  context 'as a staff leader' do
    let!(:staff) { create(:staff, leader: true) }
    let!(:team) { create(:team, staffs: [staff]) }
    let!(:staffs) { create_list(:staff, 3) }

    before { @token = authenticate staff.user }

    describe 'GET /teams' do
      it 'should fail to show all teams' do
        get '/teams', headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end

    describe 'GET /teams/1' do
      it 'should show a given team' do
        get "/teams/#{team.id}", headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response).to be_successful
        expect(data).to have_key 'staffs'
      end
    end

    describe 'POST /team' do
      it 'should create a new team' do
        post '/teams', headers: { Authorization: @token }, params: { staff_ids: staffs.map(&:id) }
        expect(response.status).to eq 401
      end
    end

    describe 'PUT /team/1' do
      it 'should update an existing team' do
        put "/teams/#{team.id}", headers: { Authorization: @token }, params: { staff_ids: staffs.map(&:id) }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'staffs'
      end
    end

    describe 'DELETE /team/1' do
      it 'should delete a team' do
        delete "/teams/#{team.id}", headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end
  end

  context 'unauthenticated' do
    let!(:staff) { create(:staff) }
    let!(:team) { create(:team) }
    let!(:staffs) { create_list(:staff, 3) }

    before { @token = authenticate staff.user}

    describe 'GET /teams' do
      it 'should show all teams' do
        get '/teams', headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end

    describe 'GET /teams/1' do
      it 'should show a given team' do
        get "/teams/#{team.id}", headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end

    describe 'POST /team' do
      it 'should create a new team' do
        post '/teams', headers: { Authorization: @token }, params: { staff_ids: staffs.map(&:id) }
        expect(response.status).to eq 401
      end
    end

    describe 'PUT /team/1' do
      it 'should update an existing team' do
        put "/teams/#{team.id}", headers: { Authorization: @token }, params: { staff_ids: staffs.map(&:id) }
        expect(response.status).to eq 401
      end
    end

    describe 'DELETE /team/1' do
      it 'should delete a team' do
        delete "/teams/#{team.id}", headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end
  end
end
