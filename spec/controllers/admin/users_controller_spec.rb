require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  before do
    @warehouse = create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: @warehouse)
    log_in(@user)
  end

  context 'GET Index' do
    it 'assigns @users' do
      user = FactoryBot.create(:admin_staff_user, warehouse: @warehouse)
      another_user = FactoryBot.create(:warehouse_user, warehouse: @warehouse)

      get :index
      expect(assigns(:users)).to eq([user, another_user])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  context "GET New" do
    it 'assigns @user' do
      get :new
      expect(assigns(:user)).to be_new_record
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

    it 'when user has errors' do
      post :create, params: {
        user: { name: "John Doe" }
      }
      expect(assigns(:user)).not_to be_persisted
      expect(response).to render_template(:new)
    end

    it 'saves record' do
      post :create, params: {
        user: {
          name: "John Doe", cellphone: "423 123 5332", email: "sample@email.com",
          email_confirmation: "sample@email.com", password: "foobar", password_confirmation: "foobar",
          warehouse_id: @warehouse.id, role: User::ROLES[:warehouse]
        }
      }
      expect(assigns(:user)).to be_persisted
      expect(response.status).to eq(302)
    end
  end

  context "GET Edit" do
    before do
      @another_user = FactoryBot.create(:admin_staff_user, warehouse: @warehouse)
    end

    it 'when id is wrong' do
      get :edit, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'assigns @user' do
      get :edit, params: { id: @another_user }
      expect(assigns(:user)).to be_same_as @another_user
    end

    it 'renders the edit template' do
      get :edit, params: { id: @another_user }
      expect(response).to render_template(:edit)
    end
  end

  context 'PUT Update' do
    before do
      @another_user = FactoryBot.create(:admin_staff_user, warehouse: @warehouse)
    end

    it 'when id is wrong' do
      put :update, params: { id: 0, user: {} }
      expect(response.status).to eq(404)
    end

    it 'renders unprocessable entity' do
      put :update, params: { id: @another_user.id }
      expect(response.status).to eq(422)
    end

    it 'when user has errors' do
      put :update, params: {
        id: @another_user.id,
        user: { name: nil }
      }

      expect(response).to render_template(:edit)
    end

    it 'saves record' do
      put :update, params: {
        id: @another_user.id,
        user: {
          name: "John Doe", cellphone: "423 123 5332",
          warehouse_id: @warehouse.id, role: User::ROLES[:warehouse]
        }
      }
      expect(assigns(:user)).to be_persisted
      expect(response.status).to eq(302)
    end
  end

  context 'DELETE Destroy' do
    before do
      @another_user = FactoryBot.create(:admin_staff_user, warehouse: @warehouse)
    end

    it 'when id is wrong' do
      delete :destroy, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should destroy user' do
      delete :destroy, params: { id: @another_user.id }
      expect(assigns(:user)).to be_inactive
    end
  end

  context 'POST Restore' do
    before do
      @another_user = FactoryBot.create(:admin_staff_user, warehouse: @warehouse)
      @another_user.destroy
    end

    it 'when id is wrong' do
      post :restore, params: { id: 0 }
      expect(response.status).to eq(404)
    end

    it 'should reactivate user' do
      post :restore, params: { id: @another_user }
      expect(assigns(:user)).to be_active
    end
  end

end
