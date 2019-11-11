require 'rails_helper'

RSpec.describe Admin::ClientsController, type: :controller do
  before do
    @warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: @warehouse)
    log_in(@user)
  end

  context 'GET Index' do
    it 'assigns @clients' do
      client = FactoryBot.create(:client, user: @user )
      another_client = FactoryBot.create(:client, user: @user )

      get :index
      expect(assigns(:clients)).to eq([client, another_client])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
      expect(response.status).to eq(200)
    end
  end

  context 'GET Show' do
    let!(:client){ FactoryBot.create(:client, user: @user) }

    it 'when id is wrong' do
      get :show, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'assigns @user' do
      get :show, params: { id: client }
      expect(assigns(:client).id).to eq(client.id)
    end

    it 'renders the show template' do
      get :show, params: { id: client }
      expect(response).to render_template(:show)
      expect(response.status).to eq(200)
    end
  end

end
