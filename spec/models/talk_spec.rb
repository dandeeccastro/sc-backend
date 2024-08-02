RSpec.describe Talk, type: :model do
  context 'free slot from 10 to 12' do
    let!(:event) { create(:event, start_date: DateTime.current.change(hour: 8)) }
    let!(:location) { create(:location) }
    let!(:type) { create(:type) }
    let!(:talks) { [ 
      create(:talk_with_event, event: event, location: location, start_date: DateTime.current.change(hour: 8), end_date: DateTime.current.change(hour: 10)),
      create(:talk_with_event, event: event, location: location, start_date: DateTime.current.change(hour: 12), end_date: DateTime.current.change(hour: 15)),
    ] }

    def generate_talk_attributes(from:, to:)
      attributes_for(:talk).merge(
        event: event, 
        location: location, 
        type: type, 
        start_date: DateTime.current.change(hour: from), 
        end_date: DateTime.current.change(hour: to))
    end

    describe 'Creation with overlap' do
      it 'should create on free slot' do
        attrs = generate_talk_attributes(from: 10, to: 12)
        talk = Talk.create(attrs)
        expect(talk.valid?).to eq(true)
      end

      it 'should fail to create overlapping on start_date' do
        attrs = generate_talk_attributes(from: 9, to: 12)
        talk = Talk.create(attrs)
        expect(talk.valid?).to eq(false)
        expect(talk.errors).to have_key(:overlap)
      end

      it 'should fail to create overlapping on end_date' do
        attrs = generate_talk_attributes(from: 10, to: 13)
        talk = Talk.create(attrs)
        expect(talk.valid?).to eq(false)
        expect(talk.errors).to have_key(:overlap)
      end

      it 'should fail to create when talk is inside the other' do
        attrs = generate_talk_attributes(from: 13, to: 14)
        talk = Talk.create(attrs)
        expect(talk.valid?).to eq(false)
        expect(talk.errors).to have_key(:overlap)
      end

      it 'should fail to create when talk is same as the other' do
        attrs = generate_talk_attributes(from: 12, to: 15)
        talk = Talk.create(attrs)
        expect(talk.valid?).to eq(false)
        expect(talk.errors).to have_key(:overlap)
      end
    end

    describe 'Creation before event' do
      it 'should fail to create talk before event' do
        attrs = generate_talk_attributes(from: 7, to: 12)
        talk = Talk.create(attrs)
        expect(talk.valid?).to eq(false)
        expect(talk.errors).to have_key(:out_of_bounds)
      end
    end
  end
end
