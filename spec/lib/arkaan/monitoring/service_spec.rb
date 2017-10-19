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

  describe :url do
    it 'has a url set at creation' do
      expect(build(:service).url).to eq 'https://test-service.com/'
    end
    it 'invalidates the service if no URL is given' do
      expect(build(:service, url: nil).valid?).to be false
    end
    it 'invalidates the service if the URL is given in a wrong format' do
      expect(build(:service, url: 'test').valid?).to be false
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
      account = build(:service)
      account.validate
      expect(account.errors.messages[:key]).to eq ['service.key.uniq']
    end
    it 'returns the right message if the URL is not given' do
      account = build(:service, url: nil)
      account.validate
      expect(account.errors.messages[:url]).to eq ['service.url.blank']
    end
    it 'returns the right message if the URL is given in the wrong format' do
      account = build(:service, url: 'test')
      account.validate
      expect(account.errors.messages[:url]).to eq ['service.url.format']
    end
  end
end