RSpec.describe Arkaan::Monitoring::Route do
  describe :path do
    it 'has a path set at creation' do
      expect(build(:route).path).to eq '/route'
    end
    it 'has a default value that is the root path' do
      expect(build(:empty_route).path).to eq '/'
    end
    it 'correctly builds a route with the root path explicitly given' do
      expect(build(:route, path: '/').valid?).to be true
    end
    it 'invalidates the path if it\'s in a wrong format' do
      expect(build(:route, path: 'essai').valid?).to be false
    end
    it 'validates a composite path with parameters' do
      expect(build(:route, path: '/test/:parameter').valid?).to be true
    end
  end

  describe :complete_path do
    let!(:service) { build(:service, path: '/test', key: 'test') }
    it 'has a complete path taking the service path in consideration' do
      expect(build(:route, path: '/truc', service: service).complete_path).to eq '/test/truc'
    end
    it 'returns the correct complete path for the root path' do
      expect(build(:route, path: '/', service: service).complete_path).to eq '/test'
    end
  end

  describe :premium do
    it 'gives a default value to the premium flag' do
      expect(build(:empty_route).premium).to be false
    end
    it 'correctly returns the premium value for a premium route' do
      expect(build(:premium_route).premium).to be true
    end
  end

  describe :active do
    it 'gives a default value to the active flag' do
      expect(build(:empty_route).active).to be true
    end
    it 'correctly returns the active value for an active route' do
      expect(build(:inactive_route).active).to be false
    end
  end

  describe :verb do
    it 'has a verb set at creation' do
      expect(build(:route).verb).to eq 'post'
    end
    it 'has a default value that is the root path' do
      expect(build(:empty_route).verb).to eq 'get'
    end
    it 'invalidates the path if it\'s in a wrong format' do
      expect(build(:route, verb: 'essai').valid?).to be false
    end
  end
end