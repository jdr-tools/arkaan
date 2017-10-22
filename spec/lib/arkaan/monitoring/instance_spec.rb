RSpec.describe Arkaan::Monitoring::Instance do
  describe :url do
    it 'has a url set at creation' do
      expect(build(:instance).url).to eq 'https://test-service.com/'
    end
    it 'invalidates the service if no URL is given' do
      expect(build(:instance, url: nil).valid?).to be false
    end
    it 'invalidates the service if the URL is given in a wrong format' do
      expect(build(:instance, url: 'test').valid?).to be false
    end
  end

  describe :service do
    it 'has a service set at creation' do
      expect(build(:instance, service: create(:service)).service.key).to eq 'test.service'
    end
  end

  describe :messages do
    it 'returns the right message if the URL is not given' do
      instance = build(:instance, url: nil)
      instance.validate
      expect(instance.errors.messages[:url]).to eq ['instance.url.blank']
    end
    it 'returns the right message if the URL is given in the wrong format' do
      instance = build(:instance, url: 'test')
      instance.validate
      expect(instance.errors.messages[:url]).to eq ['instance.url.format']
    end
  end
end