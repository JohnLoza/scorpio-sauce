require 'rails_helper'

RSpec.describe WarehouseShipment, type: :model do
  before do
    @warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: @warehouse)

    @product = FactoryBot.create(:product)

    @w_ship = WarehouseShipment.new(user: @user, warehouse: @warehouse)
    @w_ship.products = [
      { product_id: @product.id, units: "10", batch: "ABC123", expires_at: "11-10-2020" }
    ]
  end

  subject { @w_ship }

  it { should respond_to(:user) }
  it { should respond_to(:receiver) }
  it { should respond_to(:warehouse) }

  it { should respond_to(:products) }
  it { should respond_to(:status) }
  it { should respond_to(:report) }

  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }

  it { should respond_to(:processable?) }
  it { should respond_to(:reportable?) }
  it { should respond_to(:deletable?) }

  it { should respond_to(:processed?) }
  it { should respond_to(:reported?) }
  it { should respond_to(:devolution?) }

  it { should respond_to(:process_shipment) }
  it { should respond_to(:process_shipment_report) }

  context 'when user is not present' do
    before { @w_ship.user_id = nil }
    it { should_not be_valid }
  end

  context 'when user is invalid' do
    before { @w_ship.user_id = 0 }
    it { should_not be_valid }
  end

  context 'when warehouse is not present' do
    before { @w_ship.warehouse_id = nil }
    it { should_not be_valid }
  end

  context 'when warehouse is invalid' do
    before { @w_ship.warehouse_id = 0 }
    it { should_not be_valid }
  end

  context 'when products is not present' do
    before { @w_ship.products = nil }
    it { should_not be_valid }
  end

end
