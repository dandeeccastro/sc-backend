require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe 'POST #create' do
    it 'should create a new user' do
      post :create, params: { user: { name: 'Lorem Ipsum', email: 'lorem.ipsum@gmail.com', password: 'senha123' } }
      data = Oj.load response.body

      expect(data).to have_key 'user'
      expect(data).not_to have_key 'errors'
      expect(response.status).to eq 200
    end

    it 'should fail to create user without required parameters' do
      post :create, params: { user: { name: 'No Email', password: 'senha123' } }
      data = Oj.load response.body

      expect(data).to have_key 'errors'
      expect(response.status).to eq 422
    end
  end
end
