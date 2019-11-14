require 'rails_helper'

RSpec.describe Api::ClientsController, type: :controller do
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
    let!(:another_user) { FactoryBot.create(:admin, warehouse: @warehouse) }
    let!(:client_one) { FactoryBot.create(:client, user: @user) }
    let!(:client_two) { FactoryBot.create(:client, user: @user) }
    let!(:client_three) { FactoryBot.create(:client, user: another_user) }

    it 'assigns @clients' do
      get :index, params: {}
      expect(assigns(:clients)).to eq([client_one, client_two])
      expect(response.status).to eq(200)
    end

    it 'renders @clients as json' do
      get :index, params: {}
      parsed_body = JSON.parse(response.body)

      expected = assigns(:clients).as_json
      expected.each do |e|
        e["lat"] = "%f" % e["lat"].to_s
        e["lng"] = "%f" % e["lng"].to_s
      end

      expect(parsed_body["data"]).to eq(expected)
      expect(response.status).to eq(200)
    end
  end

  context 'GET Show' do
    let!(:client) { FactoryBot.create(:client, user: @user) }

    it 'when id is invalid' do
      get :show, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'assigns @client' do
      get :show, params: { id: client }
      expect(assigns(:client).id).to eq(client.id)
      expect(response.status).to eq(200)
    end

    it 'renders @client as json' do
      get :show, params: { id: client }
      parsed_body = JSON.parse(response.body)

      expected = assigns(:client).as_json
      expected["lat"] = "%f" % expected["lat"].to_s
      expected["lng"] = "%f" % expected["lng"].to_s

      expect(parsed_body["data"]).to eq(expected)
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
        client: { name: "" }
      }
      expect(assigns(:client)).not_to be_valid
      expect(assigns(:client)).not_to be_persisted
      expect(response.status).to eq(422)
    end

    it 'saves record' do
      post :create, params: {
        client: { name: "new client", address: "address", colony: "colony", zc: "44971", city_id: "19273", lat: "90.192831", lng: "108.283723", telephone: "3319283121" }
      }
      expect(assigns(:client)).to be_valid
      expect(assigns(:client)).to be_persisted
      expect(response.status).to eq(200)
    end
  end

  context 'PUT Update' do
    let!(:client) { FactoryBot.create(:client, user: @user) }
    it 'when id is invalid' do
      put :update, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'renders unprocessable entity' do
      put :update, params: { id: client }
      expect(response.status).to eq(422)
    end

    it 'when errors are present' do
      put :update, params: { id: client, client: { name: "" } }
      expect(assigns(:client)).not_to be_valid
      expect(response.status).to eq(422)
    end

    it 'saves record' do
      put :update, params: { id: client, client: { name: "new client again" } }
      expect(assigns(:client)).to be_valid
      expect(response.status).to eq(200)
    end
  end

  context 'DELETE Destroy' do
    let!(:client) { FactoryBot.create(:client, user: @user) }

    it 'when id is invalid' do
      delete :destroy, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'assigns @client' do
      delete :destroy, params: { id: client }
      expect(assigns(:client).id).to eq(client.id)
      expect(assigns(:client)).to be_inactive
      expect(response.status).to eq(200)
    end
  end

end
