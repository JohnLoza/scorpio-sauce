require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    warehouse = create(:warehouse)
    @user = FactoryBot.build(:admin_staff_user, warehouse: warehouse)
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:cellphone) }
  it { should respond_to(:email) }
  it { should respond_to(:email_confirmation) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:role) }
  it { should respond_to(:avatar) }
  it { should respond_to(:warehouse) }

  it { should respond_to(:clients) }
  it { should respond_to(:tickets) }
  it { should respond_to(:route_stocks) }

  it { should respond_to(:admin?) }
  it { should respond_to(:role?) }

  it { should be_valid }
  it { should_not be_admin }

  context 'when role is set to \'admin\'' do
    before { @user.role = User::ROLES[:admin] }
    it { should be_admin }
  end

  context 'when name is not present' do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  context 'when name is too large' do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  context 'when cellphone is not present' do
    before { @user.cellphone = " " }
    it { should_not be_valid }
  end

  context 'when cellphone is too long' do
    before { @user.cellphone = "3" * 21 }
    it { should_not be_valid }
  end

  context 'when email is not present' do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  context 'when email format is invalid' do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
        foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.email_confirmation = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  context 'when email format is valid' do
    it 'should be valid' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.email_confirmation = valid_address
        expect(@user).to be_valid
      end
    end
  end

  context 'when email address is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.email_confirmation = @user.email.upcase
      user_with_same_email.save!
    end

    it { should_not be_valid }
  end

  context 'when email confirmation is not present' do
    before { @user.email_confirmation = " " }
    it { should_not be_valid }
  end

  context 'when email doesn\'t match confirmation' do
    before { @user.email_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  context 'when password is not present' do
    before do
      @user.password = " "
      @user.password_confirmation = " "
    end

    it { should_not be_valid }
  end

  context 'when password is too long' do
    before do
      @user.password = "ab" * 12
      @user.password_confirmation = @user.password
    end
    it { should_not be_valid }
  end

  context 'when password is too short' do
    before do
      @user.password = "ab"
      @user.password_confirmation = @user.password
    end
    it { should_not be_valid }
  end

  context 'when password confirmation is not present' do
    before { @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  context 'when password doen\'t match confirmation' do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  context "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    context "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    context "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
    end
  end

  context "client associations" do
    before { @user.save }
    let!(:first_client) do
      FactoryBot.create(:client, user: @user)
    end
    let!(:second_client) do
      FactoryBot.create(:client, user: @user)
    end

    it 'should have the right clients' do
      expect(@user.clients.to_a).to eq [first_client, second_client]
    end
  end

end
