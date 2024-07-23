module Requests
  module Authenticator
    def authenticate(user)
      post '/login', params: { cpf: user.cpf, password: user.password }
      Oj.load(response.body)['token']
    end
  end
end
