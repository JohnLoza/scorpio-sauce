require 'rails_helper'

RSpec.describe Admin::WarehouseShipmentsController, type: :controller do
  before do
    @warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: @warehouse)
    log_in(@user)

    @product_one = FactoryBot.create(:product)
    @product_two = FactoryBot.create(:product)
  end

  context 'GET Index' do
    it 'assigns @warehouse_shipments' do
      w_ship_one = WarehouseShipment.new(user: @user, warehouse: @warehouse)
      w_ship_one.products = [
        { product_id: @product_one.id, units: "10", batch: "ABC123", expires_at: "11-10-2020" }
      ]
      w_ship_one.save!

      w_ship_two = WarehouseShipment.new(user: @user, warehouse: @warehouse)
      w_ship_two.products = [
        { product_id: @product_two.id, units: "20", batch: "BCA231", expires_at: "10-11-2020" }
      ]

      w_ship_two.save!

      get :index
      expect(assigns(:warehouse_shipments)).to eq([w_ship_one, w_ship_two])
      expect(response.status).to eq(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  context "GET New" do
    it 'assigns @product' do
      get :new
      expect(assigns(:warehouse_shipment)).to be_instance_of WarehouseShipment
      expect(assigns(:warehouse_shipment)).to be_new_record
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

    it 'when product has errors' do
      post :create, params: {
        warehouse_shipment: { warehouse_id: "0" },
        products: {random_hash: {product_id: "0"} }
      }

      expect(assigns(:warehouse_shipment)).not_to be_valid
      expect(assigns(:warehouse_shipment)).not_to be_persisted
      expect(response).to render_template(:new)
    end

    it 'saves record' do
      post :create, params: {
        warehouse_shipment: { warehouse_id: @warehouse.id },
        products: {
          "asdgs2341" => { product_id: @product_one.id, units: "50", batch: "ABC123", expires_at: "15-11-2020" },
          "ghjahsie2" => { product_id: @product_two.id, units: "30", batch: "BCA231", expires_at: "20-10-2020" }
        }
      }

      expect(assigns(:warehouse_shipment)).to be_valid
      expect(assigns(:warehouse_shipment)).to be_persisted
      expect(response.status).to eq(302)
    end
  end

  context 'DELETE Destroy' do
    before do
      @w_ship = WarehouseShipment.new(user: @user, warehouse: @warehouse)
      @w_ship.products = [
        { product_id: @product_one.id, units: "10", batch: "ABC123", expires_at: "11-10-2020" }
      ]
      @w_ship.save!
    end

    it 'when id is wrong' do
      delete :destroy, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should destroy product' do
      delete :destroy, params: { id: @w_ship }
      expect(assigns(:warehouse_shipment)).to be_destroyed
    end
  end

  context 'POST Process Shipment' do
    before do
      @w_ship = WarehouseShipment.new(user: @user, warehouse: @warehouse)
      @w_ship.products = [
        { product_id: @product_one.id, units: "10", batch: "ABC123", expires_at: "11-10-2020" }
      ]
      @w_ship.save!
    end

    it 'when id is wrong' do
      post :process_shipment, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should process shipment' do
      post :process_shipment, params: { id: @w_ship }

      expect(assigns(:warehouse_shipment)).to be_processed
      expect(assigns(:warehouse_shipment).receiver_user_id).to eq(@user.id)
      expect(response.status).to eq(200)
    end
  end

  context 'POST Report' do
    before do
      @w_ship = WarehouseShipment.new(user: @user, warehouse: @warehouse)
      @w_ship.products = [
        { product_id: @product_one.id, units: "10", batch: "ABC123", expires_at: "11-10-2020" }
      ]
      @w_ship.save!
    end

    it 'when id is wrong' do
      post :report, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should be reported' do
      post :report, params: { id: @w_ship, real_units: ["5"], report: { message: "missing product" } }

      expect(assigns(:warehouse_shipment)).to be_reported
      expect(response.status).to eq(200)
    end
  end

  context 'POST Processes report' do
    before do
      @w_ship = WarehouseShipment.new(user: @user, warehouse: @warehouse)
      @w_ship.products = [
        { product_id: @product_one.id, units: "10", batch: "ABC123", expires_at: "11-10-2020" }
      ]
      @w_ship.save!
    end

    it 'when id is wrong' do
      post :report, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should process report' do
      post :process_shipment, params: { id: @w_ship }

      expect(assigns(:warehouse_shipment)).to be_processed
      expect(assigns(:warehouse_shipment).receiver_user_id).to eq(@user.id)
      expect(response.status).to eq(200)
    end
  end

end
