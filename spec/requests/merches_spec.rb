require 'swagger_helper'

describe 'Merch API' do
  path '/events/{slug}/merches' do
    let(:admin) { create(:admin) }

    get 'listar mercadorias de evento' do
      tags 'Mercadoria'
      consumes 'application/json'
      parameter name: :slug, in: :path, type: :string

      response '200', 'listagem de mercadorias feita com sucesso' do
        let(:slug) { create(:event).slug }
        run_test!
      end
    end

    post 'criar mercadoria pro evento' do
      tags 'Mercadoria'
      security [token: []] 
      consumes 'multipart/form-data'
      parameter name: :slug, in: :path, type: :string

      parameter name: :name, in: :formData, type: :string
      parameter name: :image, in: :formData, type: :file, required: false
      parameter name: :price, in: :formData, type: :integer
      parameter name: :limit, in: :formData, type: :integer
      parameter name: :event_id, in: :formData, type: :integer
      parameter name: :stock, in: :formData, type: :integer
      parameter name: :custom_fields, in: :formData, type: :object, required: false

      response '201', 'criação de mercadoria feita com sucesso' do
        let!(:event) { create(:event) }
        let(:Authorization) { authenticate(admin) }
        let(:slug) { event.slug }

        let(:name) { 'Mercadoria' }
        let(:price) { 1299 }
        let(:event_id) { event.id }
        let(:stock) { 50 }
        let(:limit) { 50 }
        let(:custom_fields) { {  } }

        run_test!
      end

      response '401', 'sem permissão para criar' do
        let(:Authorization) { '' }
        let(:event) { create(:event) }
        let(:slug) { event.slug }

        let(:name) { 'Mercadoria' }
        let(:price) { 1299 }
        let(:event_id) { event.id }
        let(:stock) { 50 }
        let(:limit) { 50 }
        let(:custom_fields) { {  } }

        run_test!
      end

      # response '422', 'parâmetros inválidos' do
      #   let(:event) { create(:event) }
      #   let(:Authorization) { authenticate(admin) }
      #   let(:slug) { event.slug }
      #
      #   let(:name) { 'Mercadoria' }
      #   let(:price) { 'Jefferson' }
      #   let(:event_id) { event.id }
      #   let(:stock) { 50 }
      #   let(:limit) { 50 }
      #   let(:custom_fields) { {  } }
      #
      #   run_test!
      # end
    end
  end

  path '/events/{slug}/merches/{id}' do
    let(:event) { create(:event) }
    let(:merch) { create(:merch, event: )}
    let(:admin) { create(:admin) }

    get 'mostrar mercadoria de evento' do
      tags 'Mercadoria'
      consumes 'application/json'
      parameter name: :slug, in: :path, type: :string
      parameter name: :id, in: :path, type: :integer

      response '200', 'listagem de mercadorias feita com sucesso' do
        let(:id) { merch.id }
        let(:slug) { event.slug }
        run_test!
      end
    end
    
    put 'atualizar mercadoria de evento' do
      tags 'Mercadoria'
      security [token: []] 
      consumes 'application/json'
      parameter name: :slug, in: :path, type: :string
      parameter name: :id, in: :path, type: :integer

      parameter name: :name, in: :formData, type: :string, required: false
      parameter name: :image, in: :formData, type: :file, required: false
      parameter name: :price, in: :formData, type: :integer, required: false
      parameter name: :limit, in: :formData, type: :integer, required: false
      parameter name: :event_id, in: :formData, type: :integer, required: false
      parameter name: :stock, in: :formData, type: :integer, required: false
      parameter name: :custom_fields, in: :formData, type: :object, required: false

      response '200', 'atualização feitao com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:slug) { event.slug }
        let(:id) { merch.id }
        let(:name) { 'Nome novo' }

        run_test!
      end

      response '401', 'sem permissão para atualizar' do
        let(:Authorization) { '' }
        let(:slug) { event.slug }
        let(:id) { merch.id }
        let(:name) { 'Nome novo' }

        run_test!
      end
    end

    delete 'remover mercadoria do evento' do
      tags 'Mercadoria'
      security [token: []] 
      consumes 'application/json'
      parameter name: :slug, in: :path, type: :string
      parameter name: :id, in: :path, type: :integer

      response '200', 'remoção feita com sucesso' do
        let(:Authorization) { authenticate(admin) }
        let(:slug) { event.slug }
        let(:id) { merch.id }
        run_test!
      end
    end
  end
end
