RSpec.describe CategoryController do
  let(:attendee) { create(:attendee) }
  let(:staff) { create(:staff) }
  let(:event) { create(:event, team: create(:team, users: [staff])) }
  let(:category) { create(:category, event_id: event.id)}
  let(:other_categories) { create_list(:category, 3) }

  context 'Staff' do
    before do
      expect(subject).to receive :authenticate_user
      allow(controller).to receive(:current_user).and_return staff
    end

    describe 'GET /category' do
      it 'should list categories' do
        get :index, params: { event_slug: event.slug }
        categories = Oj.load response.body
        expect(response).to have_http_status(:ok)
        expect(categories).to be_an_instance_of(Array)
        expect(categories.length).to eq(1)
      end
    end

    describe 'POST /category' do
      it 'should create category' do
        post :create, params: { event_slug: event.slug, name: 'Categoria Nova', color: 'red' }
        category = Oj.load response.body
        expect(response).to have_http_status(:created)
        expect(category['name']).to eq('Categoria Nova')
      end
    end

    describe 'PUT /category/1' do
      it 'should update category' do
        put :update, params: { id: category.id, event_slug: event.slug, name: 'Categoria Atualizada' }
        category = Oj.load response.body
        expect(response).to have_http_status(:ok)
        expect(category['name']).to eq('Categoria Atualizada')
      end
    end

    describe 'DELETE /category/1' do
      it 'should delete category' do
        delete :destroy, params: { id: category.id }
        data = Oj.load response.body
        expect(response).to have_http_status(:ok)
        expect(data['message']).to be_an_instance_of(String)
      end
    end
  end

  context 'Regular User' do
    before do
      expect(subject).to receive :authenticate_user
      allow(controller).to receive(:current_user).and_return attendee
    end
    
    describe 'POST /category' do
      it 'should fail to create category' do
        post :create, params: { event_slug: event.slug, name: 'Categoria Nova', color: 'red' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT /category/1' do
      it 'should fail to update category' do
        put :update, params: { id: category.id, event_slug: event.slug, name: 'Categoria Atualizada' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE /category/1' do
      it 'should fail to delete category' do
        delete :destroy, params: { id: category.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
