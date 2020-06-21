RSpec.describe Arkaan::OAuth::Authorization do

  describe 'validity of a correctly built authorization' do
    it 'validates an authorization with all the parameters correctly given.' do
      expect(build(:authorization).valid?).to be true
    end
  end

  describe :account do
    it 'returns the right account for an authorization' do
      expect(build(:authorization).account.username).to eq 'Babausse'
    end
    it 'invalidates the authorization if the account is not given' do
      expect(build(:authorization, account: nil).valid?).to be false
    end
  end

  describe :application do
    it 'returns the right application for an authorization' do
      expect(build(:authorization).application.name).to eq 'My wonderful test application'
    end
    it 'invalidates the authorization if the application is not given' do
      expect(build(:authorization, application: nil).valid?).to be false
    end
  end

  describe :code do
    it 'returns the right code for a built authorization' do
      expect(build(:authorization).code).to eq 'test_code'
    end
    it 'invalidates the authorization if the code is not given' do
      expect(build(:authorization, code: nil).valid?).to be false
    end
    it 'invalidates the authorization if the code is already existing' do
      create(:authorization)
      expect(build(:authorization).valid?).to be false
    end
    it 'generates a default random value for the code' do
      expect(build(:authorization_random_code).code.size).to be 32
    end
  end

  describe :access_token do
    it 'returns the right tokens for an already built authorization' do
      expect(create(:authorization, tokens: [create(:access_token)]).tokens.first.value).to eq 'test_access_token'
    end
    it 'validates the authorization if the tokens are not given' do
      expect(build(:authorization, tokens: nil).valid?).to be true
    end
  end
end