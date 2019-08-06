RSpec.describe Arkaan::Monitoring::Vigilante do
  describe :inheritance do
    before do
      create(:vigilante)
    end
    it 'Inherits from service as a class' do
      expect(Arkaan::Monitoring::Vigilante.ancestors.include?(Arkaan::Monitoring::Service)).to be true
    end
    it 'Creates a service accessible in the list of services' do
      expect(Arkaan::Monitoring::Service.all.count).to be 1
    end
    it 'Correctly creates the service side of the vigilante' do
      expect(Arkaan::Monitoring::Service.first.key).to eq 'vigilante'
    end
    it 'Creates a vigilante accessible in the vigilante list' do
      expect(Arkaan::Monitoring::Vigilante.all.count).to be 1
    end
    it 'Correctly creates the specific side of the vigilante' do
      expect(Arkaan::Monitoring::Vigilante.first.key).to eq 'vigilante'
    end
  end

  describe :token do
    it 'has a token set at creation' do
      expect(build(:vigilante).token).to eq 'vigilante_token'
    end
    it 'invalidates the vigilante if the token is not given' do
      expect(build(:vigilante, token: nil).valid?).to be false
    end
  end

  describe :messages do
    it 'returns the right message if the token is not given' do
      vigilante = build(:vigilante, token: nil)
      vigilante.validate
      expect(vigilante.errors.messages[:token]).to eq ['required']
    end
  end
end