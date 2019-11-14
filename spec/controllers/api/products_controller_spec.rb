require 'rails_helper'

RSpec.describe Api::ProductsController, type: :controller do
  before do
    @warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:user, role: User::ROLES[:delivery_man], warehouse: @warehouse)
    @auth_token = JsonWebToken.encode(user_id: @user.id)
  end

  before(:each) { request.headers.merge!({ "Authorization" => @auth_token }) }

  context 'when a request' do
    it 'doens\'t contain the authorization token' do
      request.headers.merge!({ "Authorization" => " " })
      get :index, params: {}
      expect(response.status).to eq(401)
    end

    it 'contains an invalid authorization token' do
      request.headers.merge!({ "Authorization" => "invalid_token" })
      get :index, params: {}
      expect(response.status).to eq(401)
    end
  end

  context 'GET Index' do
    let!(:product_one) { FactoryBot.create(:product) }
    let!(:product_two) { FactoryBot.create(:product) }
    let!(:product_three) { FactoryBot.create(:product) }

    it 'assigns @products' do
      get :index, params: {}
      expect(assigns(:products)).to eq([product_one, product_two, product_three])
      expect(response.status).to eq(200)
    end

    it 'assigns @products with id param present' do
      get :index, params: { id: [product_one.id, product_three.id] }
      expect(assigns(:products)).to eq([product_one, product_three])
      expect(response.status).to eq(200)
    end

    it 'renders @products as json' do
      get :index, params: {}
      parsed_body = JSON.parse(response.body)

      expected = assigns(:products).as_json
      expected.each do |e|
        e["retail_price"] = "%.1f" % e["retail_price"].to_s
        e["half_wholesale_price"] = "%.1f" % e["half_wholesale_price"].to_s
        e["wholesale_price"] = "%.1f" % e["wholesale_price"].to_s
      end

      expect(parsed_body["data"]).to eq(expected)
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
      expect(response.status).to eq(200)
    end

    it 'renders @product as json' do
      get :show, params: { id: product }
      parsed_body = JSON.parse(response.body)

      expected = assigns(:product).as_json
      expected["retail_price"] = "%.1f" % expected["retail_price"].to_s
      expected["half_wholesale_price"] = "%.1f" % expected["half_wholesale_price"].to_s
      expected["wholesale_price"] = "%.1f" % expected["wholesale_price"].to_s

      expect(parsed_body["data"]).to eq(expected)
      expect(response.status).to eq(200)
    end
  end

end
