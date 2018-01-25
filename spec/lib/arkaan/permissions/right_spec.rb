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

  describe :category do
    it 'returns the correct category for a given right' do
      expect(create(:right).category.slug).to eq('test_category')
    end
    it 'invalidates the right if it has no category' do
      expect(build(:right, category: nil).valid?).to be false
    end
  end
end