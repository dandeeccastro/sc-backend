RSpec.describe "Categories", type: :request do
  context 'Staff' do
    let(:staff) { create(:staff) }
    let(:event) { create(:event) }
    let!(:category) { create(:category, event_id: event.id )}
    let!(:other_categories) { create_list(:category_with_event, 3) }

    before do
      event.team.update users: [staff]
      token = authenticate staff
      @headers = { Authorization: token }
    end

    describe 'GET /category' do
      it 'should list categories' do
        get "/events/#{event.slug}/category", headers: @headers
        categories = Oj.load response.body
        expect(response).to have_http_status(:ok)
        expect(categories).to be_an_instance_of(Array)
        expect(categories.length).to eq(1)
      end
    end

    describe 'POST /category' do
      it 'should create category' do
        post "/events/#{event.slug}/category", headers: @headers, params: { name: 'Categoria Nova', color: 'red' }
        category = Oj.load response.body
        expect(response).to have_http_status(:created)
        expect(category['name']).to eq('Categoria Nova') end
    end

    describe 'PUT /category/1' do
      it 'should update category' do
        put "/events/#{event.slug}/category/#{category.id}", headers: @headers, params: { name: 'Categoria Atualizada' }
        category = Oj.load response.body
        expect(response).to have_http_status(:ok)
        expect(category['name']).to eq('Categoria Atualizada')
      end
    end

    describe 'DELETE /category/1' do
      it 'should delete category' do
        delete "/events/#{event.slug}/category/#{category.id}", headers: @headers
        data = Oj.load response.body
        expect(response).to have_http_status(:ok)
        expect(data['message']).to be_an_instance_of(String)
      end
    end
  end

  context 'Regular User' do
    let!(:attendee) { create(:attendee) }
    let!(:event) { create(:event) }
    let!(:category) { create(:category, event_id: event.id)}
    let!(:other_categories) { create_list(:category_with_event, 3) }

    before do
      token = authenticate attendee
      @headers = { Authorization: token }
    end
    
    describe 'POST /category' do
      it 'should fail to create category' do
        post "/events/#{event.slug}/category", headers: @headers, params: { name: 'Categoria Nova', color: 'red' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PUT /category/1' do
      it 'should fail to update category' do
        put "/events/#{event.slug}/category/#{category.id}", headers: @headers, params: { name: 'Categoria Atualizada' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE /category/1' do
      it 'should fail to delete category' do
        delete "/events/#{event.slug}/category/#{category.id}", headers: @headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
