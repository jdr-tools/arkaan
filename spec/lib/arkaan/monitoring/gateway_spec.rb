RSpec.describe Arkaan::Monitoring::Gateway do
  describe :url do
    it 'has a url set at creation' do
      expect(build(:gateway).url).to eq 'https://gateway.test/'
    end
    it 'invalidates the service if no URL is given' do
      expect(build(:gateway, url: nil).valid?).to be false
    end
    it 'invalidates the service if the URL is given in a wrong format' do
      expect(build(:gateway, url: 'test').valid?).to be false
    end
  end

  describe :running do
    it 'has a running status set at creation' do
      expect(build(:gateway).running).to be false
    end
  end

  describe :active do
    it 'has an active status set at creation' do
      expect(build(:gateway).active).to be false
    end
  end

  describe :scopes do
    describe :running do
      before(:each) do
        create(:gateway, running: true)
      end
      it 'has a scope giving the currently running instances' do
        expect(Arkaan::Monitoring::Gateway.running.count).to be 1
      end
      it 'returns the currently running instances' do
        expect(Arkaan::Monitoring::Gateway.running.first.url).to eq 'https://gateway.test/'
      end
    end
    describe :active do
      before(:each) do
        create(:gateway, active: true)
      end
      it 'has a scope giving the currently active instances' do
        expect(Arkaan::Monitoring::Gateway.active.count).to be 1
      end
      it 'returns the currently active instances' do
        expect(Arkaan::Monitoring::Gateway.active.first.url).to eq 'https://gateway.test/'
      end
    end
    describe :inactive do
      before(:each) do
        create(:gateway, active: false)
      end
      it 'has a scope giving the currently inactive instances' do
        expect(Arkaan::Monitoring::Gateway.inactive.count).to be 1
      end
      it 'returns the currently inactive instances' do
        expect(Arkaan::Monitoring::Gateway.inactive.first.url).to eq 'https://gateway.test/'
      end
    end
  end

  describe :messages do
    it 'returns the right message if the URL is not given' do
      gateway = build(:gateway, url: nil)
      gateway.validate
      expect(gateway.errors.messages[:url]).to eq ['gateway.url.blank']
    end
    it 'returns the right message if the URL is given in the wrong format' do
      gateway = build(:gateway, url: 'test')
      gateway.validate
      expect(gateway.errors.messages[:url]).to eq ['gateway.url.format']
    end
  end
end