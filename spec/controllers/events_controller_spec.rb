require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  context 'with authenticated admin' do
    before do
      is_expected.to receive :authenticate_user
      is_expected.to receive :admin?
      @user = create(:user)
      @admin = create(:admin, user: @user)
      allow(controller).to receive(:current_user).and_return @user
      allow(controller).to receive(:admin).and_return @admin
    end

    describe 'POST #create' do
      let!(:event) { create(:event) }

      it 'should create an event when current_user is admin' do
        post :create, params: { event: { name: 'Semana da Computação 2024' } }
        data = Oj.load response.body

        expect(response.status).to eq 201
        expect(data).to have_key 'event'
      end
    end
  end

  context 'without authenticated admin' do
    before do
      is_expected.to receive :authenticate_user
      is_expected.to receive :admin?
      @user = create(:user)
      @attendee = create(:attendee, user: @user)
      allow(controller).to receive(:current_user).and_return @user
      allow(controller).to receive(:admin).and_return @attendee
    end

    describe 'POST #create' do
      it 'should prevent unauthorized user from creating event' do
        post :create, params: { event: { name: 'Evento impossível' } }
        data = Oj.load response.body

        expect(response.status).to eq 401
        expect(data).to have_key 'errors'
      end
    end
  end
end
