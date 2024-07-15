RSpec.describe TypeController do
  let(:event) { create(:event) }
  let(:user) { create(:attendee, permissions: 5) }
  let(:team) { create(:team, event: event, users: [user])}

  before do
    expect(subject).to receive :authenticate_user
    allow(controller).to receive(:current_user).and_return user
  end

  describe 'List Types' do
    context 'Authenticated as Staff from Event' do
      it 'list types' do
        get :index

        types = Oj.load response.body
        expect(response).to have_http_status(200)
        expect(types.length).to eq(0)
      end
    end
  end

  describe 'Create Type' do
    context 'Admin' do
      it 'creates type' do
        post :create, params: { name: 'Testing', color: 'orange' }

        type = Oj.load response.body

        expect(response).to have_http_status(:created)
        expect(type).to have_key('name')
        expect(type).to have_key('color')
      end
    end
  end
end
