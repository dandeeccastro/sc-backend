require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "POST /login" do
    let!(:user) { create(:user) }

    it 'should login with existing user' do
      post '/login', params: { cpf: user.cpf, password: user.password }
      data = Oj.load response.body

      expect(response.status).to eq 200
      expect(data).to have_key 'token'
      expect(data).to have_key 'exp'
    end

    it 'should fail to authenticate without proper params' do
      post '/login', params: { cpf: user.cpf, password: 'senha errada' }
      data = Oj.load response.body

      expect(response.status).to eq 401
      expect(data).to have_key 'errors'
    end
  end
end
