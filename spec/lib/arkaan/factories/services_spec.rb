RSpec.describe Arkaan::Factories::Services do
  describe :search do
    describe 'Nominal case' do
      let!(:service) { create(:service, key: 'test_factory') }

      it 'Returns a service decorator' do
        expect(Arkaan::Factories::Services.search('test_factory')).to be_a_kind_of(Arkaan::Decorators::Service)
      end
      it 'Returns a decorator with the correct service' do
        expect(Arkaan::Factories::Services.search('test_factory').object.key).to eq('test_factory')
      end
    end
    it 'Returns nil if no service exists' do
      expect(Arkaan::Factories::Services.search('test_factory')).to be nil
    end
    it 'Returns nil if services exist with a different key' do
      create(:service, key: 'other_key')
      expect(Arkaan::Factories::Services.search('test_factory')).to be nil
    end
  end
end