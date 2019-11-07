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
    end
  end

end
