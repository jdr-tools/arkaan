RSpec.describe Arkaan::Factories::Gateways do
  describe :random do
    describe 'Nominal case' do
      let!(:gateway) { create(:gateway, active: true, running: true) }

      it 'Returns a service decorator' do
        expect(Arkaan::Factories::Gateways.random('action')).to be_a_kind_of(Arkaan::Decorators::Gateway)
      end
      it 'Returns a decorator with the correct service' do
        expect(Arkaan::Factories::Gateways.random('action').object.url).to eq('https://gateway.test/')
      end
    end
    describe 'No gateway' do
      it 'Returns the correct error' do
        expect(->{ Arkaan::Factories::Gateways.random('action') }).to raise_error(Arkaan::Factories::Errors::GatewayNotFound)
      end
    end
    describe 'No running gateway' do
      let!(:gateway) { create(:gateway, active: true, running: false) }
      it 'Returns the correct error' do
        expect(->{ Arkaan::Factories::Gateways.random('action') }).to raise_error(Arkaan::Factories::Errors::GatewayNotFound)
      end
    end
    describe 'No active gateway' do
      let!(:gateway) { create(:gateway, active: false, running: true) }
      it 'Returns the correct error' do
        expect(->{ Arkaan::Factories::Gateways.random('action') }).to raise_error(Arkaan::Factories::Errors::GatewayNotFound)
      end
    end
  end
end