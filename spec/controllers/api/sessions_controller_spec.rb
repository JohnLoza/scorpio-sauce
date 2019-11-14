require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
  before do
    @warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:user, role: User::ROLES[:delivery_man], warehouse: @warehouse)
  end

  context 'POST Create' do
    it 'session params are not present' do
      post :create, params: {}
      expect(response.status).to eq(401)
    end

    it 'session params are invalid' do
      post :create, params: {
        session: {email: "e@mail.com", password: "foobar"}
      }
      expect(response.status).to eq(401)
    end

    it 'password session param is invalid' do
      post :create, params: {
        session: {email: @user.email, password: "ali223"}
      }
      expect(response.status).to eq(401)
    end

    it 'renders authentication token' do
      post :create, params: {
        session: {email: @user.email, password: "foobar" }
      }
      parsed_body = JSON.parse(response.body)

      expect(parsed_body["data"]).to be_present
      expect(response.status).to eq(200)
    end
  end

end
