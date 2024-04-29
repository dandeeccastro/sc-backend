require 'rails_helper'

def authenticate(user)
  post '/login', params: { email: user.email, password: user.password }
  Oj.load(response.body)['token']
end

RSpec.describe "Users", type: :request do
  context 'as an admin' do
    let!(:admin) { create(:admin) }
    let!(:users) { create_list(:user, 3) }

    before { @token = authenticate admin.user }

    describe 'GET /user' do
      it 'should list users when authenticated with admin' do
        get '/user', headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to be_an_instance_of Array
        expect(data.length).to eq 4
      end
    end

    describe 'GET /user/1' do
      it 'should return user information when requester is admin' do
        get "/user/#{admin.user.id}", headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'email'
        expect(data['id']).not_to eq admin.user.id
      end
    end

    describe 'PUT /user/1' do
      it 'should update own user information' do
        put "/user/#{admin.user.id}", headers: { Authorization: @token }, params: { user: { name: 'Nome Alterado', email: 'email@alterado.com' } }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data['email']).to eq 'email@alterado.com'
      end
    end
  end

  context 'normal user' do
    let!(:attendee) { create(:attendee) }

    before { @token = authenticate attendee.user }

    describe 'GET /user' do
      it 'should fail to list when user is not admin' do
        get '/user', headers: { Authorization: @token }
        expect(response.status).to eq 401
      end
    end

    describe 'GET /user/1' do
      it "should show user's own information" do
        get "/user/#{attendee.user.id}", headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'email'
        expect(data['email']).to eq attendee.user.email
      end
    end

    describe 'PUT /user/1' do
      it 'should update oneself' do
        put "/user/#{attendee.user.id}", headers: { Authorization: @token }, params: { user: { name: 'Nome Alterado', email: 'email@alterado.com' } }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data['email']).to eq 'email@alterado.com'
      end
    end

    describe 'DELETE /user/1' do
      it 'should delete given user' do
        delete "/user/#{attendee.user.id}", headers: { Authorization: @token }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'message'
      end
    end
  end

  context 'unauthenticated' do
    describe 'POST /register' do
      it 'should create user with params' do
        post '/register', params: { user: { name: 'Danilo', email: 'user@gmail.com', password: 'senha123' } }
        data = Oj.load response.body

        expect(response.status).to eq 200
        expect(data).to have_key 'email'
      end

      it 'should fail to create without required params' do
        post '/register', params: { user: { email: 'user@gmail.com', password: 'senha123' } }
        data = Oj.load response.body

        expect(response.status).to eq 422
        expect(data).to have_key 'errors'
      end
    end
  end
end
