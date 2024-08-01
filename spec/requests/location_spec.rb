RSpec.describe "Locations", type: :request do
  context 'regular user' do
    let!(:attendee) { create(:attendee) }
    let!(:locations) { create_list(:location, 3) }
    
    describe 'GET /location' do
      it 'should list all locations' do
        get "/location", headers: { Authorization: authenticate(attendee) }
        data = Oj.load(response.body)
        expect(data).to be_an_instance_of(Array)
        expect(data.length).to eq(3)
      end
    end
  end

  context 'staff leader' do
    let!(:staff_leader) { create(:staff_leader) }
    let!(:location) { create(:location) }

    describe 'POST /location' do
      it 'should create location' do
        post "/location", headers: { Authorization: authenticate(staff_leader) }, params: { name: 'Localização Teste'}
        data = Oj.load(response.body)
        expect(data).to be_an_instance_of(Hash)
        expect(data['name']).to eq('Localização Teste')
      end
    end

    describe 'PUT /location/1'  do
      it 'should update location' do
        put "/location/#{location.id}", headers: { Authorization: authenticate(staff_leader) }, params: { name: 'Nome Novo para Localização' }
        data = Oj.load(response.body)
        expect(data).to be_an_instance_of(Hash)
        expect(data['name']).to eq('Nome Novo para Localização')
      end
    end

    describe 'DELETE /location/1' do
      it 'should delete location' do
        delete "/location/#{location.id}", headers: { Authorization: authenticate(staff_leader) }
        data = Oj.load(response.body)
        expect(data).to be_an_instance_of(Hash)
        expect(data).to have_key('message')
      end
    end
  end
end
