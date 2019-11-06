require 'rails_helper'

RSpec.describe Admin::WarehousesController, type: :controller do

  before do
    @warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: @warehouse)
    log_in(@user)
  end

  context 'GET Index' do
    it 'assigns @warehouses' do
      another_warehouse = FactoryBot.create(:warehouse)

      get :index
      expect(assigns(:warehouses)).to eq([@warehouse, another_warehouse])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  context 'GET New' do
    it 'assigns @warehouse' do
      get :new
      expect(assigns(:warehouse)).to be_new_record
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  context 'POST Create' do
    it 'renders unprocessable entity' do
      post :create
      expect(response.status).to eq(422)
    end

    it 'when warehouse has errors' do
      post :create, params: {
        warehouse: { name: nil }
      }
      expect(response).to render_template(:new)
    end

    it 'saves the record' do
      post :create, params: {
        warehouse: { address: "warehouse address", telephone: "33 12 93 81 78", city_id: 19597 }
      }
      expect(assigns(:warehouse)).to be_persisted
      expect(response.status).to eq(302)
    end
  end

  context "GET Edit" do
    it 'when id is wrong' do
      get :edit, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'assigns @warehouse' do
      get :edit, params: { id: @warehouse }
      expect(assigns(:warehouse).id).to eq(@warehouse.id)
    end

    it 'renders the edit template' do
      get :edit, params: { id: @warehouse }
      expect(response).to render_template(:edit)
    end
  end

  context 'PUT Update' do
    it 'when id is wrong' do
      put :update, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'renders unprocessable entity' do
      put :update, params: { id: @warehouse }
      expect(response.status).to eq(422)
    end

    it 'when warehouse has errors' do
      put :update, params: {
        id: @warehouse,
        warehouse: { address: nil }
      }

      expect(response).to render_template(:edit)
    end

    it 'saves record' do
      put :update, params: {
        id: @warehouse,
        warehouse: { address: "new address" }
      }
      expect(assigns(:warehouse).errors.any?).to eq(false)
      expect(response.status).to eq(302)
    end
  end

  context 'DELETE Destroy' do
    it 'when id is wrong' do
      delete :destroy, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should destroy warehouse' do
      delete :destroy, params: { id: @warehouse }
      expect(assigns(:warehouse)).to be_inactive
    end
  end

  context 'POST Restore' do
    before { @warehouse.destroy }

    it 'when id is wrong' do
      post :restore, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should reactivate warehouse' do
      post :restore, params: { id: @warehouse }
      expect(assigns(:warehouse)).to be_active
    end
  end

end
