RSpec.describe Arkaan::Monitoring::Vigilante do
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