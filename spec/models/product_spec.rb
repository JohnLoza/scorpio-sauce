require 'rails_helper'

RSpec.describe Product, type: :model do
  before do
    @product = FactoryBot.build(:product)
  end

  subject { @product }

  it { should respond_to(:name) }
  it { should respond_to(:retail_price) }
  it { should respond_to(:half_wholesale_price) }
  it { should respond_to(:required_units_half_wholesale) }
  it { should respond_to(:wholesale_price) }
  it { should respond_to(:required_units_wholesale) }
  it { should respond_to(:main_image) }
  it { should respond_to(:boxes) }
  it { should respond_to(:deleted_at) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }

  it { should be_valid }

  context 'when name is not present' do
    before { @product.name = " " }
    it { should_not be_valid }
  end

  context 'when retail price is not present' do
    before { @product.retail_price = nil }
    it { should_not be_valid }
  end

  context 'when half wholesale price is not present' do
    before { @product.half_wholesale_price = nil }
    it { should_not be_valid }
  end

  context 'when half wholesale price is greater than retail price' do
    before { @product.half_wholesale_price = @product.retail_price + 1 }
    it { should_not be_valid }
  end

  context 'when required units half wholesale is not present' do
    before { @product.required_units_half_wholesale = nil }
    it { should_not be_valid }
  end

  context 'when required units half wholesale is too low' do
    it '(it is less than zero)' do
      @product.required_units_half_wholesale = -5
      expect(subject).to_not be_valid
    end

    it '(it is zero)' do
      @product.required_units_half_wholesale = 0
      expect(subject).to_not be_valid
    end
  end

  context 'when wholesale price is not present' do
    before { @product.wholesale_price = nil }
    it{ should_not be_valid }
  end

  context 'when wholesale price is greater than half wholesale price' do
    before { @product.wholesale_price = @product.half_wholesale_price + 1 }
    it { should_not be_valid }
  end

  context 'when required units wholesale is not present' do
    before{ @product.required_units_wholesale = nil }
    it{ should_not be_valid }
  end

  context 'when required units wholesale is too low' do
    it '(is is lower than half wholesale)' do
      @product.required_units_wholesale = @product.required_units_half_wholesale - 5
      expect(subject).not_to be_valid
    end

    it '(it is same as half wholesale)' do
      @product.required_units_wholesale = @product.required_units_half_wholesale
      expect(subject).not_to be_valid
    end
  end

end
