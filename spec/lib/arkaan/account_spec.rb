RSpec.describe Arkaan::Account do

  describe 'validity of a correctly built account' do
    it 'validates an account with all the parameters correctly given.' do
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
    it 'invalidates the account if the username is already taken' do
      create(:conflicting_username_account)
      expect(build(:account).valid?).to be false
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
    it 'invalidates the account if the email is not given' do
      expect(build(:account, email: nil).valid?).to be false
    end
    it 'invalidates the account if the email is already in the database' do
      create(:conflicting_email_account)
      expect(build(:account).valid?).to be false
    end
  end

  describe :groups do
    it 'returns the right number of groups for a given account' do
      expect(create(:account_with_groups).groups.count).to be 1
    end
    it 'returns the right group for an account with a group' do
      expect(create(:account_with_groups).groups.first.slug).to eq 'test_group'
    end
  end

  describe :applications do
    it 'returns the right number of applications for a given account' do
      expect(create(:account_with_applications).applications.count).to be 1
    end
    it 'returns the right application for an account with an application' do
      expect(create(:account_with_applications).applications.first.name).to eq 'My wonderful test application'
    end
  end

  describe :authorizations do
    it 'returns the right authorizations for a given account' do
      expect(create(:account_with_authorizations).authorizations.count).to be 1
    end
    it 'returns the right authorization for an account with an authorization' do
      expect(create(:account_with_authorizations).authorizations.first.code).to eq 'test_code'
    end
  end
end