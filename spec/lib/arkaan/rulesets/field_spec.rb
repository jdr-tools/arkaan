RSpec.describe Arkaan::Rulesets::Field do

  let!(:account) { create(:account) }
  let!(:ruleset) { create(:ruleset, creator: account) }
  let!(:blueprint) { create(:blueprint, ruleset: ruleset) }

  describe :name do
    it 'has a name set at creation' do
      expect(build(:integer_field, blueprint: blueprint).name).to eq 'test_field'
    end
    it 'invalidates the field if the name is not given' do
      expect(build(:integer_field, name: nil, blueprint: blueprint).valid?).to be false
    end
    it 'invalidates the field if the name is given with the wrong format' do
      expect(build(:integer_field, name: 'test wrong format', blueprint: blueprint).valid?).to be false
    end
    it 'invalidates the field if the name is less than four characters' do
      expect(build(:integer_field, name: 'foo', blueprint: blueprint).valid?).to be false
    end
    it 'invalidates the field if the name is already used in this blueprint' do
      create(:integer_field, blueprint: blueprint)
      expect(build(:integer_field, blueprint: blueprint).valid?).to be false
    end
  end

  describe 'Integer field' do
    describe :type do
      it 'has a type set at creation' do
        expect(build(:integer_field, blueprint: blueprint).type).to eq :Integer
      end
    end
    describe 'default values' do
      it 'sets the correct default value if the max is not given' do
        expect(build(:integer_field, blueprint: blueprint, data: {}).data[:max]).to be nil
      end
      it 'sets the correct default value if the min is not given' do
        expect(build(:integer_field, blueprint: blueprint, data: {}).data[:min]).to be nil
      end
    end
    describe 'errors' do
      it 'invalidates the field if the max is not an integer' do
        expect(build(:integer_field, blueprint: blueprint, data: {max: 'test'}).valid?).to be false
      end
      it 'invalidates the field if the min value is not an integer' do
        expect(build(:integer_field, blueprint: blueprint, data: {min: 'test'}).valid?).to be false
      end
    end
    describe 'errors.messages' do
      it 'returns the right message if the max value is not an integer' do
        field = build(:integer_field, blueprint: blueprint, data: {max: 'test'})
        field.validate
        expect(field.errors.messages[:data]).to eq(['max|type'])
      end
      it 'returns the right message if the min value is not an integer' do
        field = build(:integer_field, blueprint: blueprint, data: {min: 'test'})
        field.validate
        expect(field.errors.messages[:data]).to eq(['min|type'])
      end
    end
  end

  describe 'Gauge field' do
    let!(:data) {
      return {
        min: 50,
        max: 200,
        initial: 100,
        show: false
      }
    }

    describe 'attributes' do
      let!(:field) { build(:gauge_field, blueprint: blueprint, data: data) }
      it 'returns the right type if the field type is a Gauge' do
        expect(field.type).to eq :Gauge
      end
    end
    describe 'default values' do
      it 'sets the correct default value if the max is not given' do
        expect(build(:gauge_field, blueprint: blueprint, data: {initial: 100, show: false, min: 50}).data[:max]).to be 100
      end
      it 'sets the correct default value if the min is not given' do
        expect(build(:gauge_field, blueprint: blueprint, data: {initial: 100, show: false, max: 200}).data[:min]).to be 0
      end
      it 'sets the correct default value is the initial is not given' do
        expect(build(:gauge_field, blueprint: blueprint, data: {max: 100, show: false, min: 50}).data[:initial]).to be 0
      end
      it 'sets the correct default value if the show option is not given' do
        expect(build(:gauge_field, blueprint: blueprint, data: {max: 200, initial: 100, min: 50}).data[:show]).to be true
      end
    end
    describe 'errors' do
      it 'invalidates the gauge if the max is not an integer' do
        expect(build(:gauge_field, blueprint: blueprint, data: {max: 'test'}).valid?).to be false
      end
      it 'invalidates the gauge if the min value is not an integer' do
        expect(build(:gauge_field, blueprint: blueprint, data: {min: 'test'}).valid?).to be false
      end
      it 'invalidates the gauge if the initial is not an integer' do
        expect(build(:gauge_field, blueprint: blueprint, data: {initial: 'test'}).valid?).to be false
      end
      it 'invalidates the gauge if the show option is not a boolean' do
        expect(build(:gauge_field, blueprint: blueprint, data: {show: 'test'}).valid?).to be false
      end
    end
    describe 'errors.messages' do
      it 'returns the right message if the max value is not an integer' do
        gauge = build(:gauge_field, blueprint: blueprint, data: {max: 'test'})
        gauge.validate
        expect(gauge.errors.messages[:data]).to eq(['max|type'])
      end
      it 'returns the right message if the initial value is not an integer' do
        gauge = build(:gauge_field, blueprint: blueprint, data: {initial: 'test'})
        gauge.validate
        expect(gauge.errors.messages[:data]).to eq(['initial|type'])
      end
      it 'returns the right message if the show option is not a boolean' do
        gauge = build(:gauge_field, blueprint: blueprint, data: {show: 'test'})
        gauge.validate
        expect(gauge.errors.messages[:data]).to eq(['show|type'])
      end
    end
  end

  describe 'errors.messages' do
    it 'returns the right message if the name is not given' do
      field = build(:integer_field, blueprint: blueprint, name: nil)
      field.validate
      expect(field.errors.messages[:name]).to eq(['required'])
    end
    it 'returns the right message if the name is less than four characters' do
      field = build(:integer_field, blueprint: blueprint, name: 'foo')
      field.validate
      expect(field.errors.messages[:name]).to eq(['minlength'])
    end
    it 'returns the correct message if the name has not a correct format' do
      field = build(:integer_field, blueprint: blueprint, name: 'wrong format')
      field.validate
      expect(field.errors.messages[:name]).to eq(['pattern'])
    end
    it 'returns the correct message if the name is already used in this blueprint' do
      create(:integer_field, blueprint: blueprint)
      field = build(:integer_field, blueprint: blueprint)
      field.validate
      expect(field.errors.messages[:name]).to eq(['uniq'])
    end
    it 'returns the correct message if the type is not authorized' do
      create(:integer_field, blueprint: blueprint)
    end
  end
end