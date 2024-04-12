require 'rails_helper'

RSpec.describe "Users", type: :request do
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
end
