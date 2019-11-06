require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  before { @warehouse = FactoryBot.build(:warehouse) }
  subject { @warehouse }

  it { should respond_to(:address) }
  it { should respond_to(:telephone) }
  it { should respond_to(:city) }

  it { should be_valid }

  context 'when address is not present' do
    before { @warehouse.address = " " }
    it { should_not be_valid }
  end

  context 'when address is too long' do
    before { @warehouse.address = "a" * 102 }
    it { should_not be_valid }
  end

  context 'when telephone is not present' do
    before { @warehouse.telephone = " " }
    it { should_not be_valid }
  end

  context 'when telephone is too short' do
    before { @warehouse.telephone = "21" }
    it { should_not be_valid }
  end

  context 'when telephone is too long' do
    before { @warehouse.telephone = "3"*21 }
    it { should_not be_valid }
  end

  context 'when city is not present' do
    before { @warehouse.city_id = nil }
    it { should_not be_valid }
  end

  context 'when city doesn\'t exist' do
    before { @warehouse.city_id = 0 }
    it { should_not be_valid }
  end

end
