RSpec.describe Arkaan::Account do
  describe :username do
    it 'has a username set at creation' do
      expect(Arkaan::Account.new(username: 'test_username').username).to eq('test_username')
    end
    it 'invalidates the account if the username is less than six characters' do
      expect(Arkaan::Account.new(username: 'test').valid?).to be false
    end
    it 'invalidates the account if the username is not given' do
      expect(Arkaan::Account.new.valid?).to be false
    end
  end

  describe :password do
    it 'fails to build a user if the password confirmation is not given' do
      expect(Arkaan::Account.new(password: 'password').valid?).to be false
    end
    it 'fails to build a user if the password confirmation is not the same as the password' do
      expect(Arkaan::Account.new(password: 'password', password_confirmation: 'test').valid?).to be false
    end
    it 'fails to build a user if the password is not given' do
      expect(Arkaan::Account.new(username: 'username').valid?).to be false
    end
  end
end