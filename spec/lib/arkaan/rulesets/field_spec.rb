RSpec.describe Arkaan::Rulesets::Field do

  let!(:account) { create(:account) }
  let!(:ruleset) { create(:ruleset, creator: account) }
  let!(:blueprint) { create(:blueprint, ruleset: ruleset) }

  describe :name do
    it 'has a name set at creation' do
      expect(build(:field, blueprint: blueprint).name).to eq 'test_field'
    end
    it 'invalidates the field if the name is not given' do
      expect(build(:field, name: nil, blueprint: blueprint).valid?).to be false
    end
    it 'invalidates the field if the name is given with the wrong format' do
      expect(build(:field, name: 'test wrong format', blueprint: blueprint).valid?).to be false
    end
    it 'invalidates the field if the name is less than four characters' do
      expect(build(:field, name: 'foo', blueprint: blueprint).valid?).to be false
    end
    it 'invalidates the field if the name is already used in this blueprint' do
      create(:field, blueprint: blueprint)
      expect(build(:field, blueprint: blueprint).valid?).to be false
    end
  end
  describe :type do
    it 'has a type set at creation' do
      expect(build(:field, blueprint: blueprint).type).to eq :Integer
    end
    it 'sets the type with the default value if it does not exist' do
      expect(build(:field, type: :anything, blueprint: blueprint).type).to eq :Integer
    end
    it 'validates the field if the field type is a String' do
      expect(build(:field, type: :String, blueprint: blueprint).valid?).to be true
    end
    it 'validates the field if the field type is a Datetime' do
      expect(build(:field, type: :DateTime, blueprint: blueprint).valid?).to be true
    end
  end
  describe 'errors.messages' do
    it 'returns the right message if the name is not given' do
      field = build(:field, blueprint: blueprint, name: nil)
      field.validate
      expect(field.errors.messages[:name]).to eq(['required'])
    end
    it 'returns the right message if the name is less than four characters' do
      field = build(:field, blueprint: blueprint, name: 'foo')
      field.validate
      expect(field.errors.messages[:name]).to eq(['minlength'])
    end
    it 'returns the correct message if the name has not a correct format' do
      field = build(:field, blueprint: blueprint, name: 'wrong format')
      field.validate
      expect(field.errors.messages[:name]).to eq(['pattern'])
    end
    it 'returns the correct message if the name is already used in this blueprint' do
      create(:field, blueprint: blueprint)
      field = build(:field, blueprint: blueprint)
      field.validate
      expect(field.errors.messages[:name]).to eq(['uniq'])
    end
    it 'returns the correct message if the type is not authorized' do
      create(:field, blueprint: blueprint)
    end
  end
end