RSpec.describe Arkaan::Utils::MicroService do
  before do
    create(:service)
  end

  describe 'Initial state' do
    let!(:instance) { Class.new(Arkaan::Utils::MicroService).instance }

    it 'has a default service name set at creation' do
      expect(instance.name).to be false
    end
    it 'has a default service path set at creation' do
      expect(instance.path).to be false
    end
    it 'has a default location set at creation' do
      expect(instance.location).to be false
    end
    it 'is not considered loadable at creation' do
      expect(instance.loadable?).to be false
    end
  end
  describe :register_as do
    let!(:instance) { Class.new(Arkaan::Utils::MicroService).instance }
    let!(:registered) { instance.register_as('test.service') }

    it 'returns the singleton to chain other calls on it' do
      expect(registered).to be(instance)
    end
    it 'correctly sets the name of the service in the singleton' do
      expect(registered.name).to eq('test.service')
    end
    it 'is still not loadable after that' do
      expect(registered.loadable?).to be false
    end
  end
  describe :from_location do
    let!(:instance) { Class.new(Arkaan::Utils::MicroService).instance }
    let!(:located) { instance.from_location('from/this/file.rb') }

    it 'returns the singleton to chain other calls on it' do
      expect(located).to be(instance)
    end
    it 'correctly sets the location of the application in the singleton' do
      expect(located.location).to eq('from/this')
    end
    it 'is still not loadable after that' do
      expect(located.loadable?).to be false
    end
  end
end