RSpec.describe Arkaan::Monitoring::Vigilante do
  describe :token do
    it 'has a token set at creation' do
      expect(build(:vigilante).token).to eq 'vigilante_token'
    end
    it 'invalidates the vigilante if the token is not given' do
      expect(build(:vigilante, token: nil).valid?).to be false
    end
  end

  describe :max_results do
    it 'has a max number of results set at creation' do
      expect(build(:vigilante, max_results: 2).max_results).to be 2
    end
    it 'has a default max number of results' do
      expect(build(:vigilante).max_results).to be 20
    end
    it 'fails if the max number is zero' do
      expect(build(:vigilante, max_results: 0).valid?).to be false
    end
    it 'fails if the max number is a negative number' do
      expect(build(:vigilante, max_results: -1).valid?).to be false
    end
  end

  describe :results_full? do
    it 'says that results are not full if there is room left' do
      expect(build(:vigilante).results_full?).to be false
    end
    it 'says that results are full if there is no room left' do
      expect(build(:vigilante, max_results: 1, reports: [build(:report)]).results_full?).to be true
    end
    it 'says results are full if it exceeds the max number of results' do
      reports = [build(:report), build(:report)]
      expect(build(:vigilante, max_results: 1, reports: reports).results_full?).to be true
    end
  end

  describe :erase_oldest_result do

  end

  describe :messages do
    it 'returns the right message if the token is not given' do
      vigilante = build(:vigilante, token: nil)
      vigilante.validate
      expect(vigilante.errors.messages[:token]).to eq ['required']
    end
  end
end