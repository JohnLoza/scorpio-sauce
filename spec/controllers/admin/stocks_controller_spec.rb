require 'rails_helper'

RSpec.describe Admin::StocksController, type: :controller do
  before do
    @product = FactoryBot.create(:product)
    @warehouse = create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: @warehouse)
    log_in(@user)
  end

  context 'GET Index' do
    it 'assigns @stocks' do
      stock_one = FactoryBot.create(:stock, warehouse: @warehouse, product: @product, batch: "ABC123")
      stock_two = FactoryBot.create(:stock, warehouse: @warehouse, product: @product, batch: "BAC152")

      get :index
      expect(assigns(:stocks)).to eq([stock_one, stock_two])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  context 'GET PrintQr' do
    before { @stock = FactoryBot.create(:stock, warehouse: @warehouse, product: @product, batch: "ABC123") }

    it 'when id is invalid' do
      get :print_qr, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'assigns @stock' do
      get :print_qr, params: { id: @stock }
      expect(assigns(:stock).id).to eq(@stock.id)
      expect(response.status).to eq(200)
    end

    it 'renders the print_qr template' do
      get :print_qr, params: { id: @stock }
      expect(response).to render_template(:print_qr)
      expect(response.status).to eq(200)
    end
  end

end
