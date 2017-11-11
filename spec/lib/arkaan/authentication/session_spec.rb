RSpec.describe Arkaan::Authentication::Session do
  describe :token do
    it 'returns the right token for a given session' do
      expect(build(:session).token).to eq 'session_token'
    end
    it 'fails at validating the session if the token is not given' do
      expect(build(:session, token: nil).valid?).to be false
    end
    it 'fails at validating the session if the token is not uniq' do
      create(:session)
      expect(build(:session, token: 'session_token').valid?).to be false
    end
    it 'fails at validating the session if the token is less than ten characters' do
      expect(build(:session, token: 'token').valid?).to be false
    end
  end

  describe :expiration do
    it 'has a default of zero, as the session is not maintained by default' do
      expect(build(:empty_session).expiration).to be 0
    end
    it 'returns the right value for a given session' do
      expect(build(:maintained_session).expiration).to be 3600
    end
    it 'fails at validating the session if the value is not given' do
      expect(build(:session, expiration: nil).valid?).to be false
    end
  end

  describe :account do
    it 'returns the right account for a given session' do
      expect(build(:session, account: build(:account)).account.username).to eq 'Babausse'
    end
  end

  describe :messages do
    it 'returns the right message if the token is not given' do
      session = build(:session, token: nil)
      session.validate
      expect(session.errors.messages[:token]).to eq(['session.token.blank'])
    end
    it 'returns the right message if the token is too short' do
      session = build(:session, token: 'token')
      session.validate
      expect(session.errors.messages[:token]).to eq(['session.token.short'])
    end
    it 'returns the right message if the token is already taken' do
      create(:session)
      session = build(:session)
      session.validate
      expect(session.errors.messages[:token]).to eq(['session.token.uniq'])
    end
    it 'returns the right message if the expiration is not given' do
      session = build(:session, expiration: nil)
      session.validate
      expect(session.errors.messages[:expiration]).to eq(['session.expiration.blank'])
    end
  end
end