RSpec.describe Arkaan::Rulesets::Blueprint do

  let!(:account) { create(:account) }
  let!(:ruleset) { create(:ruleset, creator: account) }
  let!(:other_ruleset) { create(:ruleset, name: 'other ruleset', creator: account) }

  describe 'validity of a correctly build blueprint' do
    it 'validates a correctly built blueprint' do
      expect(build(:blueprint, ruleset: ruleset).valid?).to be true
    end
  end

  describe :name do
    it 'has a name set at creation' do
      expect(build(:blueprint, ruleset: ruleset).name).to eq 'test blueprint'
    end
    it 'validates the blueprint if the name is used in another ruleset' do
      create(:blueprint, ruleset: other_ruleset)
      expect(build(:blueprint, ruleset: ruleset).valid?).to be true
    end
    it 'invalidates the blueprint if the name is not given' do
      expect(build(:blueprint, name: nil, ruleset: ruleset).valid?).to be false
    end
    it 'invalidates the blueprint if the name is less than four characters' do
      expect(build(:blueprint, name: 'foo', ruleset: ruleset).valid?).to be false
    end
    it 'invalidates the blueprint if the name is already used in the ruleset' do
      create(:blueprint, ruleset: ruleset)
      expect(build(:blueprint, ruleset: ruleset).valid?).to be false
    end
  end
  describe :fields do
    let!(:blueprint) { create(:blueprint, ruleset: ruleset) }
    let!(:field) { create(:integer_field, blueprint: blueprint) }

    it 'has a list of fields set at creation' do
      expect(blueprint._fields.count).to be 1
    end
    it 'has the correct fields set at creation' do
      expect(blueprint._fields.first.name).to eq 'test_field'
    end
  end
  describe :ruleset do
    it 'has a ruleset set at creation' do
      expect(build(:blueprint, ruleset: ruleset).ruleset.name).to eq 'test ruleset'
    end
  end
  describe 'errors.messages' do
    it 'returns the correct message when the name is not given' do
      invalid_blueprint = build(:blueprint, name: nil, ruleset: ruleset)
      invalid_blueprint.validate
      expect(invalid_blueprint.errors.messages[:name]).to eq(['required'])
    end
    it 'returns the right message when the name is less than four characters' do
      invalid_blueprint = build(:blueprint, name: 'foo', ruleset: ruleset)
      invalid_blueprint.validate
      expect(invalid_blueprint.errors.messages[:name]).to eq(['minlength'])
    end
    it 'returns the right message if the name is already used in the ruleset' do
      create(:blueprint, ruleset: ruleset)
      invalid_blueprint = build(:blueprint, ruleset: ruleset)
      invalid_blueprint.validate
      expect(invalid_blueprint.errors.messages[:name]).to eq(['uniq'])
    end
  end
end