require 'rails_helper'

RSpec.describe SupplyOrder, type: :model do
  before do
    @warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: @warehouse)

    @product = FactoryBot.create(:product)
    @supply_order = SupplyOrder.new(user_id: @user.id, target_user_id: @user.id, warehouse_id: @warehouse.id,
      to_supply: [{product_id: @product.id, units: 50}], status: "new")
  end

  subject { @supply_order }

  it { should respond_to(:user) }
  it { should respond_to(:target_user) }
  it { should respond_to(:supplier) }
  it { should respond_to(:warehouse) }
  it { should respond_to(:route_stock) }

  it { should respond_to(:to_supply) }
  it { should respond_to(:status) }

  it { should respond_to(:cancelable?) }
  it { should respond_to(:processable?) }
  it { should respond_to(:supply) }

  it { should be_valid }

  context 'when user is not present' do
    before { @supply_order.user_id = nil }
    it { should_not be_valid }
  end

  context 'when user is invalid' do
    before { @supply_order.user_id = 0 }
    it { should_not be_valid }
  end

  context 'when target_user is not present' do
    before { @supply_order.target_user_id = nil }
    it { should_not be_valid }
  end

  context 'when target_user is invalid' do
    before { @supply_order.target_user_id = 0 }
    it { should_not be_valid }
  end

  context 'when warehouse is not present' do
    before { @supply_order.warehouse_id = nil }
    it { should_not be_valid }
  end

  context 'when warehouse is invalid' do
    before { @supply_order.warehouse_id = 0 }
    it { should_not be_valid }
  end

  context 'when to_supply' do
    it 'product_id key is missing' do
      @supply_order.to_supply[0].except!("product_id")
      expect(subject).not_to be_valid
    end

    it 'units key is missing' do
      @supply_order.to_supply[0].except!("units")
      expect(subject).not_to be_valid
    end

    it 'has an unknown key' do
      @supply_order.to_supply[0]["unknown"] = "unknown value"
      expect(subject).not_to be_valid
    end
  end

end
