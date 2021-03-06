require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:first_name) }
  it { is_expected.to respond_to(:last_name) }
  it { is_expected.to respond_to(:address_1) }
  it { is_expected.to respond_to(:address_2) }
  it { is_expected.to respond_to(:city) }
  it { is_expected.to respond_to(:state) }
  it { is_expected.to respond_to(:zip) }
  it { is_expected.to respond_to(:birthdate) }
  it { is_expected.to respond_to(:fach_id) }
  it { is_expected.to respond_to(:admin) }

  describe 'defaults' do
    it 'is not an admin' do 
      user = FactoryGirl.create(:user)
      expect(user.admin).to be_falsey
    end
  end

  describe 'validations' do 
    let(:user) { FactoryGirl.create(:user) }

    ["password", "email", "first_name", "last_name"].each do |attribute|
      it "is invalid without a #{attribute}" do 
        user.send("#{attribute}=".to_sym, nil)
        expect(user).not_to be_valid
      end
    end

    it 'is invalid without a unique email' do 
      user2 = FactoryGirl.create(:user)
      user2.email = user.email
      expect(user2).not_to be_valid
    end
  end

  describe 'full_name' do 
    it 'concatenates the first and last names' do 
      user = FactoryGirl.create(:user)
      expect(user.full_name).to eql 'User Name'
    end
  end

  describe 'age' do 
    context 'when the user has a birthdate' do 
      it 'returns the user\'s age' do 
        user = FactoryGirl.create(:user, birthdate: Date.current.years_ago(25))
        expect(user.age).to eql 25
      end
    end
  end
end
