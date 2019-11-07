require 'rails_helper'

RSpec.describe Client, type: :model do
  before do
    warehouse = FactoryBot.create(:warehouse)
    @user = FactoryBot.create(:admin, warehouse: warehouse)
    @client = FactoryBot.build(:client, user: @user)
  end

  subject { @client }

  it { should respond_to(:name) }
  it { should respond_to(:telephone) }
  it { should respond_to(:address) }
  it { should respond_to(:colony) }
  it { should respond_to(:zc) }
  it { should respond_to(:lat) }
  it { should respond_to(:lng) }

  it { should respond_to(:user) }
  it { should respond_to(:city) }

  it { should respond_to(:location) }
  it { should respond_to(:full_address) }
  it { should respond_to(:google_maps_link) }

  it { should be_valid }

  context 'when name is not present' do
    before { @client.name = " " }
    it { should_not be_valid }
  end

  context 'when name is too long' do
    before { @client.name = "a" * 55 }
    it { should_not be_valid }
  end

  context 'when telephone is not present' do
    before { @client.telephone = " " }
    it { should_not be_valid }
  end

  context 'when telephone is too long' do
    before { @client.telephone = "3" * 21 }
    it { should_not be_valid }
  end

  context 'when telephone is too short' do
    before { @client.telephone = "331293817" }
    it { should_not be_valid }
  end

  context 'when address is not present' do
    before { @client.address = " " }
    it { should_not be_valid }
  end

  context 'when address is too long' do
    before { @client.address = "a" * 151 }
    it { should_not be_valid }
  end

  context 'when colony is not present' do
    before { @client.colony = " " }
    it { should_not be_valid }
  end

  context 'when colony is too long' do
    before { @client.colony = "a" * 26 }
    it { should_not be_valid }
  end

  context 'when zc is not present' do
    before { @client.zc = " " }
    it { should_not be_valid }
  end

  context 'when zc is less than 5 chars' do
    before { @client.zc = "1234" }
    it { should_not be_valid }
  end

  context 'when zc is longer than 5 chars' do
    before { @client.zc = "123456" }
    it { should_not be_valid }
  end

  context 'when lat is not present' do
    before { @client.lat = nil }
    it { should_not be_valid }
  end

  context 'when lng is not present' do
    before { @client.lng = nil }
    it { should_not be_valid }
  end

  context 'when city is not present' do
    before { @client.city_id = nil }
    it { should_not be_valid }
  end

  context 'when city is invalid' do
    before { @client.city_id = 0 }
    it { should_not be_valid }
  end

  context 'when user is not present' do
    before { @client.user_id = nil }
    it { should_not be_valid }
  end

  context 'when user is invalid' do
    before { @client.user_id = 0 }
    it { should_not be_valid }
  end

end
