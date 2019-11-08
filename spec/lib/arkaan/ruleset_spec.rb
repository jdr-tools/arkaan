RSpec.describe Arkaan::Ruleset do

  let!(:account) { create(:account) }

  describe 'Validity of a well built ruleset' do
    it 'validates an account correctly built' do
      expect(build(:ruleset, creator: account).valid?).to be true
    end
  end

  describe :name do
    it 'has a name set at creation' do
      expect(build(:ruleset, creator: account).name).to eq 'test ruleset'
    end
    it 'invalidates the ruleset if the name is not given' do
      expect(build(:ruleset, name: nil, creator: account).valid?).to be false
    end
    it 'invalidates the ruleset if the name is less than 4 characters' do
      expect(build(:ruleset, name: 'foo', creator: account).valid?).to be false
    end
    it 'invalidates the ruleset if the name already exists' do
      create(:ruleset, creator: account)
      expect(build(:ruleset, creator: account).valid?).to be false
    end
  end

  describe :description do
    it 'has a description set at creation' do
      expect(build(:ruleset, creator: account).description).to eq 'description'
    end
  end

  describe 'errors.messages' do
    it 'returns the right message if the name is not given' do
      invalid_ruleset = build(:ruleset, name: nil, creator: account)
      invalid_ruleset.validate
      expect(invalid_ruleset.errors.messages[:name]).to eq(['required'])
    end
    it 'returns the right message if the name is less than 4 characters' do
      invalid_ruleset = build(:ruleset, name: 'foo', creator: account)
      invalid_ruleset.validate
      expect(invalid_ruleset.errors.messages[:name]).to eq(['minlength'])
    end
    it 'returns the right message if the name is already used' do
      create(:ruleset, creator: account)
      invalid_ruleset = build(:ruleset, creator: account)
      invalid_ruleset.validate
      expect(invalid_ruleset.errors.messages[:name]).to eq(['uniq'])
    end
  end
end