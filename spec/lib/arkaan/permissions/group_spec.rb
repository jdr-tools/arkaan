RSpec.describe Arkaan::Permissions::Group do

  describe 'validity of a correctly built group' do
    it 'validates a group with all the parameters correctly given.' do
      expect(build(:group).valid?).to be true
    end
  end

  include_examples 'slug', :group, 'test_group'

  describe :accounts do
    it 'returns the right number of accounts for a given group' do
      expect(create(:group_with_members).accounts.count).to be 1
    end
    it 'returns the right username for a user located in a group' do
      expect(create(:group_with_members).accounts.first.username).to eq 'Babausse'
    end
  end

  describe :rights do
    it 'returns the right number of rights for a given group' do
      expect(create(:group_with_rights).rights.count).to be 1
    end
    it 'returns the right slug for a right located in a group' do
      expect(create(:group_with_rights).rights.first.slug).to eq 'test_right'
    end
  end
end