module Requests
  module Authenticator
    def authenticate(user)
      post '/login', params: { email: user.email, password: user.password }
      Oj.load(response.body)['token']
    end
  end
end
