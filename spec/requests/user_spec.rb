require 'rails_helper'

def authenticate(user)
  post '/login', params: { email: user.email, password: user.password }
  Oj.load(response.body)['token']
end

RSpec.describe "Users", type: :request do
  describe 'GET /user' do
    let!(:user) { create(:user) }
    let!(:admin) { create(:admin, user: user) }

    it 'should list users when authenticated with admin' do
      token = authenticate user
      get '/user', headers: { Authorization: token }
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data).to have_key 'users'
      expect(data['users']).to be_an_instance_of Array
    end
  end

  describe 'GET /user/1' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user, email: 'other@email.com', dre: '22222222222') }
    let!(:admin) { create(:admin, user: other_user) }
    it "should show user's own information" do
      token = authenticate user
      get "/user/#{user.id}", headers: { Authorization: token }
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data).to have_key 'user'
      expect(data['user']['id']).to eq user.id
    end

    it 'should return user information when requester is admin' do
      token = authenticate other_user
      get "/user/#{user.id}", headers: { Authorization: token }
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data).to have_key 'user'
      expect(data['user']['id']).not_to eq other_user.id
    end
  end

  describe 'POST /register' do
    it 'should create user with params' do
      post '/register', params: { user: { name: 'Danilo', email: 'user@gmail.com', password: 'senha123' } }
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data).to have_key 'user'
    end

    it 'should fail to create without required params' do
      post '/register', params: { user: { email: 'user@gmail.com', password: 'senha123' } }
      data = Oj.load response.body

      expect(response.status).to eq 422
      expect(data).to have_key 'errors'
    end
  end

  describe 'PUT /user/1' do
    let!(:user) { create(:user) }
    it 'should update own user information' do
      token = authenticate user
      put "/user/#{user.id}", headers: { Authorization: token }, params: { user: { name: 'Nome Alterado', email: 'email@alterado.com' } }
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data['user']['email']).to eq 'email@alterado.com'
    end
  end

  describe 'DELETE /user/1' do
    let!(:user) { create(:user) }
    it 'should delete given user' do
      token = authenticate user
      delete "/user/#{user.id}", headers: { Authorization: token }
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data).to have_key 'message'
    end
  end
end