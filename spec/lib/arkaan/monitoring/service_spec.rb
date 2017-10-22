RSpec.describe Arkaan::Monitoring::Service do
  describe :key do
    it 'has a key set at creation' do
      expect(build(:service).key).to eq 'test.service'
    end
    it 'invalidates the service if the name is already taken' do
      create(:service)
      expect(build(:service).valid?).to be false
    end
  end

  describe :path do
    it 'has a path set at creation' do
      expect(build(:service).path).to eq '/example'
    end
    it 'has a default value that is the root path' do
      expect(build(:empty_service).path).to eq '/'
    end
    it 'invalidates the path if it\'s in a wrong format' do
      expect(build(:service, path: 'essai').valid?).to be false
    end
  end

  describe :creator do
    it 'has a creator set at creation' do
      expect(build(:service, creator: create(:account)).creator.username).to eq 'Babausse'
    end
  end

  describe :messages do
    it 'returns the right message if the key is already taken' do
      create(:service)
      service = build(:service)
      service.validate
      expect(service.errors.messages[:key]).to eq ['service.key.uniq']
    end
    it 'returns the right message if the path is not in the right format' do
      service = build(:service, path: 'essai')
      service.validate
      expect(service.errors.messages[:path]).to eq ['service.path.format']
    end
  end
end