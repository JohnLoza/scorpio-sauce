require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  before do
    @warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: @warehouse)
    log_in(@user)
  end

  context 'GET Index' do
    it 'assigns @products' do
      product = FactoryBot.create(:product)
      another_product = FactoryBot.create(:product)
      inactive_product = FactoryBot.create(:inactive_product)

      get :index
      expect(assigns(:products)).to eq([product, another_product])
      expect(assigns(:products)).not_to include(inactive_product)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
      expect(response.status).to eq(200)
    end
  end

  context 'GET Show' do
    let!(:product) { FactoryBot.create(:product) }

    it 'when id is invalid' do
      get :show, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'assigns @product' do
      get :show, params: { id: product }
      expect(assigns(:product).id).to eq(product.id)
    end

    it 'renders the show template' do
      get :show, params: { id: product }
      expect(response).to render_template(:show)
      expect(response.status).to eq(200)
    end
  end

  context "GET New" do
    it 'assigns @product' do
      get :new
      expect(assigns(:product)).to be_instance_of Product
      expect(assigns(:product)).to be_new_record
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
      expect(response.status).to eq(200)
    end
  end

  context 'POST Create' do
    it 'renders unprocessable entity' do
      post :create
      expect(response.status).to eq(422)
    end

    it 'when errors are present' do
      post :create, params: {
        product: { name: "salsa scorpio 225ml" }
      }
      expect(assigns(:product)).not_to be_persisted
      expect(response).to render_template(:new)
      expect(response.status).to eq(200)
    end

    it 'saves record' do
      post :create, params: {
        product: {
          name: "Salsa scorpio 225ml", retail_price: 25,
          half_wholesale_price: 20, required_units_half_wholesale: 5,
          wholesale_price: 15, required_units_wholesale: 10
        }
      }
      expect(assigns(:product)).to be_persisted
      expect(response.status).to eq(302)
    end
  end

  context "GET Edit" do
    let!(:product){ FactoryBot.create(:product) }

    it 'when id is invalid' do
      get :edit, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'assigns @product' do
      get :edit, params: { id: product }
      expect(assigns(:product).id).to eq(product.id)
    end

    it 'renders the edit template' do
      get :edit, params: { id: product }
      expect(response).to render_template(:edit)
      expect(response.status).to eq(200)
    end
  end

  context 'PUT Update' do
    let!(:product){ FactoryBot.create(:product) }

    it 'when id is invalid' do
      put :update, params: { id: 0, product: {} }
      expect(response.status).to eq(404)
    end

    it 'renders unprocessable entity' do
      put :update, params: { id: product }
      expect(response.status).to eq(422)
    end

    it 'when product has errors' do
      put :update, params: {
        id: product,
        product: { name: nil }
      }

      expect(response).to render_template(:edit)
      expect(response.status).to eq(200)
    end

    it 'saves record' do
      put :update, params: {
        id: product,
        product: { name: "new sauce_name" }
      }
      expect(assigns(:product).errors.any?).to eq(false)
      expect(response.status).to eq(302)
    end
  end

  context 'DELETE Destroy' do
    let!(:product){ FactoryBot.create(:product) }

    it 'when id is invalid' do
      delete :destroy, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should destroy product' do
      delete :destroy, params: { id: product }
      expect(assigns(:product)).to be_inactive
      expect(response.status).to eq(302)
    end
  end

  context 'POST Restore' do
    before {
      @product = FactoryBot.create(:product)
      @product.destroy
    }

    it 'when id is invalid' do
      post :restore, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should reactivate user' do
      post :restore, params: { id: @product }
      expect(assigns(:product)).to be_active
      expect(response.status).to eq(302)
    end
  end

end
