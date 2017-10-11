RSpec.describe Arkaan::OAuth::Application do
  describe :name do
    it 'returns the right name for a built application' do
      expect(build(:application).name).to eq 'My wonderful test application'
    end
    it 'invalidates the application if the name is not given' do
      expect(build(:application, name: nil).valid?).to be false
    end
    it 'invalidates the application if the name is less than six characters' do
      expect(build(:application, name: 'test').valid?).to be false
    end
    it 'invalidates the application if the name is already taken' do
      create(:application)
      expect(build(:application).valid?).to be false
    end
  end

  describe :key do
    it 'returns the right key for a built application' do
      expect(build(:application, key: 'test_key').key).to eq 'test_key'
    end
    it 'invalidates the application if the key is not given' do
      expect(build(:application, key: nil).valid?).to be false
    end
    it 'invalidates the application if the key is already taken' do
      create(:application, key: 'test_key')
      expect(build(:application, key: 'test_key').valid?).to be false
    end
    it 'gives the key a default random value to the key' do
      expect(build(:application).key.size).to be 32
    end
  end

  describe :creator do
    it 'returns the correct creator for a built application' do
      expect(build(:application).creator.username).to eq 'Babausse'
    end
    it 'invalidates the application if no creator is given' do
      expect(build(:application, creator: nil).valid?).to be false
    end
  end
end