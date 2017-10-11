RSpec.describe Arkaan::Permissions::Right do
  
  include_examples 'slug', :right, 'test_right'
  
  describe :groups do
    it 'returns the right number of groups for a given group' do
      expect(create(:right_with_groups).groups.count).to be 1
    end
    it 'returns the right group slug for a user located in a group' do
      expect(create(:right_with_groups).groups.first.slug).to eq 'test_group'
    end
  end
end