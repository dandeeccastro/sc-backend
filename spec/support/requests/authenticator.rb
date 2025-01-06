module Requests
  module Authenticator
    def authenticate(user)
      post '/login', params: { cpf: user.cpf, password: user.password }
      response.parsed_body['token']
    end
  end
end
