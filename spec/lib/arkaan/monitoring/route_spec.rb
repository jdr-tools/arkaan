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
  end

  describe :premium do
    it 'gives a default value to the premium flag' do
      expect(build(:empty_route).premium).to be false
    end
    it 'correctly returns the premium value for a premium route' do
      expect(build(:premium_route).premium).to be true
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