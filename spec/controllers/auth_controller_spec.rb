require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  describe 'POST #login' do
    let!(:user) { create(:user) }

    it 'should login to existing user' do
      post :login, params: { email: 'lorem.ipsum@gmail.com', password: 'senha123' }
      data = Oj.load response.body

      expect(data).not_to have_key 'errors'
      expect(data).to have_key 'token'
      expect(data).to have_key 'exp'
      expect(response.status).to eq 200
    end

    it 'should fail to authenticate with invalid credentials' do
      post :login, params: { email: 'lorem.ipsum@gmail.com', password: 'senhaerrada' }
      data = Oj.load response.body

      expect(data).to have_key 'errors'
      expect(response.status).to eq 401
    end
  end
end
