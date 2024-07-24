RSpec.describe "Users", type: :request do
  context 'as staff leader' do
    let!(:staff_leader) { create(:staff_leader) }
    let!(:event) { create(:event) }
    let!(:talk) { create(:talk_with_event, event: event)}
    let!(:vacancies) { create_list(:vacancy_with_user, 4, talk: talk) }
    let!(:users) { create_list(:attendee, 3)}

    before do
      event.team.update users: [staff_leader]
      @headers = { Authorization: authenticate(staff_leader) }
    end

    describe 'GET /user' do
      it 'should list users when authenticated with admin' do
        get '/user', headers: @headers, params: { event_slug: event.slug }
        data = Oj.load(response.body)

        expect(response.status).to eq(200)
        expect(data).to be_an_instance_of(Array)
        expect(data.length).to eq(8)
      end
    end

    describe 'GET /user/1' do
      it 'should get info from a single user' do
        get "/user/#{users.first.id}", headers: @headers, params: { event_slug: event.slug }
        data = Oj.load(response.body)

        expect(response.status).to eq(200)
        expect(data).to be_an_instance_of(Hash)
      end
    end
    
    describe 'PUT /user/1' do
      it 'should be able to update user permissions' do
        put "/user/#{users.first.id}", headers: @headers, params: { event_slug: event.slug, permissions: User::ATTENDEE | User::STAFF, name: 'Another name' }
        data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data['permissions']).to eq(User::ATTENDEE | User::STAFF)
        expect(data['name']).not_to eq('Another name')
      end

      it 'should fail to do priviledge escalation' do
        put "/user/#{users.first.id}", headers: @headers, params: { event_slug: event.slug, permissions: User::ADMIN | User::STAFF }
        data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data['permissions'].to_i & User::ADMIN).to eq(0)
      end
    end

    describe 'GET /events/:slug/users' do
      it 'should list users from event' do
        get "/events/#{event.slug}/users", headers: @headers
        data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data).to be_an_instance_of(Array)
        expect(data.length).to eq(4)
      end
    end

    describe 'GET /admin' do
      it 'should check if user is admin' do
        get '/admin', headers: @headers
        data = Oj.load(response.body)
        expect(response).to have_http_status(:ok)
        expect(data).to eq(false)
      end
    end

    describe 'DELETE /user' do
      it 'should fail to delete another users data' do
        delete "/user/#{users.first.id}", headers: { Authorization: authenticate(users.second) }
        data = Oj.load(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(data).to be_an_instance_of(Hash)
        expect(data['message']).to eq('Não tem permissão para executar ação!')
      end
    end
  end

  context 'as regular user' do
    let!(:users) { create_list(:attendee, 2) }
    let!(:event) { create(:event) }

    describe 'GET /user' do
      it 'should fail to list users when attendee' do
        get '/user', headers: { Authorization: authenticate(users.first) }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET /user/1' do
      it 'should get info from oneself' do
        get "/user/#{users.first.id}", headers: { Authorization: authenticate(users.first) }
        data = Oj.load(response.body)

        expect(response.status).to eq(200)
        expect(data).to be_an_instance_of(Hash)
      end
    end

    describe 'PUT /user/1' do
      it 'should be able to update own data except permissions' do
        put "/user/#{users.first.id}", headers: { Authorization: authenticate(users.first)}, params: { permissions: User::ADMIN, name: 'Another name' }
        data = Oj.load(response.body)

        expect(response).to have_http_status(:ok)
        expect(data['permissions']).not_to eq(User::ADMIN)
        expect(data['name']).to eq('Another name')
      end
    end

    describe 'DELETE /user' do
      it 'should delete self' do
        delete "/user/#{users.first.id}", headers: { Authorization: authenticate(users.first) }
        data = Oj.load(response.body)
        expect(data).to be_an_instance_of(Hash)
        expect(data['message']).to eq('Usuário deletado com sucesso!')
      end

      it 'should fail to delete another users data' do
        delete "/user/#{users.first.id}", headers: { Authorization: authenticate(users.second) }
        data = Oj.load(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(data).to be_an_instance_of(Hash)
        expect(data['message']).to eq('Não tem permissão para executar ação!')
      end
    end
  end
end
