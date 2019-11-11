require 'rails_helper'

RSpec.describe Stock, type: :model do
  before do
    @warehouse = FactoryBot.create(:warehouse)
    @product = FactoryBot.create(:product)

    @stock = FactoryBot.build(:stock, warehouse: @warehouse, product: @product, batch: "ABC1234")
  end

  subject { @stock }

  it { should respond_to(:warehouse) }
  it { should respond_to(:product) }

  it { should respond_to(:units) }
  it { should respond_to(:batch) }
  it { should respond_to(:expires_at) }

  it { should respond_to(:withdraw!) }
  it { should respond_to(:add!) }
  it { should respond_to(:has_minimum_stock?) }
  it { should respond_to(:data_for_qr) }

  context 'when warehouse is not present' do
    before { @stock.warehouse_id = nil }
    it { should_not be_valid }
  end

  context 'when warehouse is not valid' do
    before { @stock.warehouse_id = 0 }
    it { should_not be_valid }
  end

  context 'when product is not present' do
    before { @stock.product_id = nil }
    it { should_not be_valid }
  end

  context 'when product is not valid' do
    before { @stock.product_id = 0 }
    it { should_not be_valid }
  end

  context 'when units is not present' do
    before { @stock.units = nil }
    it { should_not be_valid }
  end

  context 'when units is less than 0' do
    before { @stock.units = -1 }
    it { should_not be_valid }
  end

  context 'when units is not a number' do
    before { @stock.units = "abcs" }
    it { should_not be_valid }
  end

  context 'when batch is not present' do
    before { @stock.batch = " " }
    it { should_not be_valid }
  end

  context 'when batch is too long' do
    before { @stock.batch = "s" * 16 }
    it { should_not be_valid }
  end

  context 'when batch is already taken' do
    before do
      another_stock = @stock.dup
      another_stock.save!
    end
    it { should_not be_valid }
  end

  context 'when expires_at is not present' do
    before { @stock.expires_at = " " }
    it { should_not be_valid }
  end

end
