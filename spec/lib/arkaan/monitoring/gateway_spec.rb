RSpec.describe Arkaan::Monitoring::Gateway do

  include_examples 'diagnostic', :gateway, '/status'

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

  describe :token do
    it 'has a token set at creation' do
      expect(build(:gateway).token).to eq 'test_token'
    end
    it 'invalidates the gateway if the token is not given' do
      expect(build(:gateway, token: nil).valid?).to be false
    end
    it 'invalidates the gateway if the token is already existing' do
      create(:gateway)
      expect(build(:gateway).valid?).to be false
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
    it 'returns the right message if the token is not given' do
      gateway = build(:gateway, token: nil)
      gateway.validate
      expect(gateway.errors.messages[:token]).to eq ['gateway.token.blank']
    end
    it 'returns the right message if the token already exists' do
      create(:gateway)
      gateway = build(:gateway)
      gateway.validate
      expect(gateway.errors.messages[:token]).to eq ['gateway.token.uniq']
    end
  end
end