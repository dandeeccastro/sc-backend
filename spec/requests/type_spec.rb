RSpec.describe "Types", headers: @headers, type: :request do
  context 'Admin' do
    let!(:event) { create(:event) }
    let!(:admin) { create(:admin)}
    let!(:type) { create(:type) }

    before { @headers = { Authorization: authenticate(admin) } }

    describe 'POST /type' do
      it 'should create new type as admin' do
        post "/type", headers: @headers, params: { name: 'Testing', color: 'orange' }
        type = Oj.load response.body
        expect(response).to have_http_status(:created)
        expect(type).to have_key('name')
        expect(type).to have_key('color')
      end
    end

    describe 'PUT /type/1' do
      it 'should update existing type' do
        put "/type/#{type.id}", headers: @headers, params: { id: type.id, name: 'Another Name' }
        type = Oj.load(response.body)
        expect(response).to have_http_status(:ok)
        expect(type['name']).to eq('Another Name')
      end
    end

    describe 'DELETE /type/1' do
      it 'should delete existing type' do
        delete "/type/#{type.id}", headers: @headers, params: { id: type.id }
        data = Oj.load(response.body)
        expect(response).to have_http_status(:ok)
        expect(data).to have_key('message')
      end
    end
  end

  context 'Regular User' do
    let(:event) { create(:event) }
    let(:type) { create(:type) }
    let(:user) { create(:attendee) }

    before { @headers = { Authorization: authenticate(user) } }

    describe 'GET /type' do
      it 'should list types as regular user' do
        get "/type", headers: @headers
        types = Oj.load response.body
        expect(response).to have_http_status(200)
        expect(types.length).to eq(0)
      end
    end

    describe 'POST /type' do
      it 'should fail to create type as regular user' do
        post "/type", headers: @headers, params: { name: 'Testing', color: 'orange' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT /type/1' do
      it 'should update existing type' do
        put "/type/#{type.id}", headers: @headers, params: { id: type.id, name: 'Another Name' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE /type/1' do
      it 'should delete existing type' do
        delete "/type/#{type.id}", headers: @headers, params: { id: type.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
