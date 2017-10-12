RSpec.describe Arkaan::OAuth::RefreshToken do
  describe :value do
    it 'returns the right value for a built token' do
      expect(build(:refresh_token).value).to eq 'test_refresh_token'
    end
    it 'invalidates the refresh token if the value is not given' do
      expect(build(:refresh_token, value: nil).valid?).to be false
    end
    it 'invalidates the refresh token if the value is already existing' do
      create(:refresh_token, authorization: create(:authorization))
      expect(build(:refresh_token).valid?).to be false
    end
    it 'generates a default random value for the token value' do
      expect(build(:empty_refresh_token).value.size).to be 32
    end
  end

  describe :authorization do
    it 'returns the right authorization for a built refresh token' do
      expect(create(:refresh_token, authorization: create(:authorization)).authorization.code).to eq 'test_code'
    end
    it 'invalidates the refresh token if the authorization is not given' do
      expect(build(:refresh_token, authorization: nil).valid?).to be false
    end
  end
end