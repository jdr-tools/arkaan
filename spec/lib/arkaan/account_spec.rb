RSpec.describe Arkaan::Account do
  describe 'validity of a correctly built account' do
    it 'Validates an account with all the parameters correctly given.' do
      expect(build(:account).valid?).to be true
    end
  end
  describe :username do
    it 'has a username set at creation' do
      expect(build(:account).username).to eq('Babausse')
    end
    it 'invalidates the account if the username is less than six characters' do
      expect(build(:account, username: 'test').valid?).to be false
    end
    it 'invalidates the account if the username is not given' do
      expect(build(:account, username: nil).valid?).to be false
    end
  end

  describe :password do
    it 'fails to build a user if the password confirmation is not the same as the password' do
      expect(build(:account, password_confirmation: 'test').valid?).to be false
    end
    it 'fails to build a user if the password is not given' do
      expect(build(:account, password: nil).valid?).to be false
    end
  end

  describe :lastname do
    it 'returns the correct last name for a built account' do
      expect(build(:account).lastname).to eq 'Courtois'
    end
    it 'returns an empty string (and not nil) if no last name has been defined' do
      expect(build(:empty_account).lastname).to eq ''
    end
  end

  describe :firstname do
    it 'returns the correct first name for a built account' do
      expect(build(:account).firstname).to eq 'Vincent'
    end
    it 'returns an empty string (and not nil) if no first name has been defined' do
      expect(build(:empty_account).firstname).to eq ''
    end
  end

  describe :birthdate do
    it 'correctly returns the birth date for a built account' do
      expect(build(:account).birthdate).to eq DateTime.new(2000, 1, 1)
    end
    it 'returns nil if the birth date is not given' do
      expect(build(:empty_account).birthdate).to eq nil
    end
  end

  describe :email do
    it 'correctly returns the email for a built account' do
      expect(build(:account).email).to eq 'courtois.vincent@outlook.com'
    end
    it 'invalidates the account if the email has the wrong format' do
      expect(build(:account, email: 'test').valid?).to be false
    end
  end
end