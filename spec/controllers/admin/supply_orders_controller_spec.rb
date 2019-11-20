require 'rails_helper'

RSpec.describe Admin::SupplyOrdersController, type: :controller do
  before do
    @warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: @warehouse)

    @product = FactoryBot.create(:product)
    @stock = FactoryBot.create(:stock, product: @product, warehouse: @warehouse, batch: "ABC1234")

    log_in(@user)
  end

  context 'GET Index' do
    let!(:supply_o_one) {
      SupplyOrder.create(user_id: @user.id, target_user_id: @user.id, warehouse_id: @warehouse.id,
        to_supply: [{product_id: @product.id, units: 150}])
    }
    let!(:supply_o_two) {
      SupplyOrder.create(user_id: @user.id, target_user_id: @user.id, warehouse_id: @warehouse.id,
        to_supply: [{product_id: @product.id, units: 50}])
    }

    it 'assigns @supply_orders' do
      get :index
      expect(assigns(:supply_orders)).to eq([supply_o_one, supply_o_two])
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
      expect(response.status).to eq(200)
    end
  end

  context 'GET Show' do
    let!(:supply_order) {
      SupplyOrder.create(user_id: @user.id, target_user_id: @user.id, warehouse_id: @warehouse.id,
        to_supply: [{product_id: @product.id, units: 150}])
    }

    it 'when id is invalid' do
      get :show, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'assigns @supply_order' do
      get :show, params: { id: supply_order.id }
      expect(assigns(:supply_order).id).to eq(supply_order.id)
      expect(response.status).to eq(200)
    end

    it 'renders the show template' do
      get :show, params: { id: supply_order.id }
      expect(response).to render_template(:show)
      expect(response.status).to eq(200)
    end
  end

  context 'GET New' do
    it 'assigns @supply_order' do
      get :new
      expect(assigns(:supply_order)).to be_new_record
      expect(response.status).to eq(200)
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
        supply_order: { target_user_id: "0" },
        products: {random_hash: {product_id: "0"} }
      }

      expect(assigns(:supply_order)).not_to be_valid
      expect(assigns(:supply_order)).not_to be_persisted
      expect(response).to render_template(:new)
    end

    it 'saves record' do
      post :create, params: {
        supply_order: { target_user_id: @user.id },
        products: {random_hash: {product_id: @product.id, units: "100"}}
      }

      expect(assigns(:supply_order)).to be_valid
      expect(assigns(:supply_order)).to be_persisted
      expect(response.status).to eq(302)
    end
  end

  context 'DELETE Destroy' do
    let!(:supply_order) {
      SupplyOrder.create(user_id: @user.id, target_user_id: @user.id, warehouse_id: @warehouse.id,
        to_supply: [{product_id: @product.id, units: 150}])
    }

    it 'when id is invalid' do
      delete :destroy, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should destroy product' do
      delete :destroy, params: { id: supply_order }
      expect(assigns(:supply_order).status).to eq(SupplyOrder::STATUS[:canceled])
    end
  end

  context 'POST Supply' do
    let!(:supply_order) {
      SupplyOrder.create(user_id: @user.id, target_user_id: @user.id, warehouse_id: @warehouse.id,
        to_supply: [{product_id: @product.id.to_s, units: 150}])
    }

    it 'when id is invalid' do
      delete :destroy, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'when errors are present' do
      post :supply, params: { id: supply_order,
        products: { random_hash: {product_id: @product.id, units: 150, batch: "nonexistent"}} }

      expect(response).to render_template(:show)
      expect(response.status).to eq(200)
    end

    xit 'saves record' do
      post :supply, params: { id: supply_order,
        products: { random_hash: {product_id: @product.id, units: 150, batch: "ABC1234"}} }

      expect(response.status).to eq(302)
    end
  end


end
