RSpec.describe Arkaan::Monitoring::Service do

  include_examples 'diagnostic', :service, '/status'

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

  describe :active do
    it 'has an active status set at creation' do
      expect(build(:service).active).to be false
    end
  end

  describe :premium do
    it 'has a premium only flag set at creation' do
      expect(build(:service, premium: true).premium).to be true
    end
    it 'sets the premium flag to false by default' do
      expect(build(:service).premium).to be false
    end
  end

  describe :routes do
    it 'has routes set up at creation' do
      expect(create(:service_with_routes).routes.count).to be 1
    end
    describe :path do
      it 'returns the correct routes paths for a created service' do
        expect(create(:service_with_routes).routes.first.path).to eq '/route'
      end
    end
    describe :verb do
      it 'returns the correct routes method for a created service' do
        expect(create(:service_with_routes).routes.first.verb).to eq 'get'
      end
    end
    describe :premium do
      it 'returns the right premium flag wfor a created route' do
        expect(create(:service_with_premium_routes).routes.first.premium).to be true
      end
      it 'creates the route with a default value of false for the premium flag' do
        expect(create(:service_with_routes).routes.first.premium).to be false
      end
    end
  end

  describe :scopes do
    describe :active do
      before(:each) do
        create(:service, active: true)
      end
      it 'has a scope giving the currently active instances' do
        expect(Arkaan::Monitoring::Service.active.count).to be 1
      end
      it 'returns the currently active instances' do
        expect(Arkaan::Monitoring::Service.active.first.key).to eq 'test.service'
      end
    end
    describe :inactive do
      before(:each) do
        create(:service, active: false)
      end
      it 'has a scope giving the currently inactive instances' do
        expect(Arkaan::Monitoring::Service.inactive.count).to be 1
      end
      it 'returns the currently inactive instances' do
        expect(Arkaan::Monitoring::Service.inactive.first.key).to eq 'test.service'
      end
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