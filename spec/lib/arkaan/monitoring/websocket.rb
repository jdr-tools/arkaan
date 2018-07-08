RSpec.describe Arkaan::Monitoring::Instance do
  describe :url do
    it 'has a url set at creation' do
      expect(build(:websocket).url).to eq 'https://test-websocket.com/'
    end
    it 'invalidates the service if no URL is given' do
      expect(build(:websocket, url: nil).valid?).to be false
    end
    it 'invalidates the service if the URL is given in a wrong format' do
      expect(build(:websocket, url: 'test').valid?).to be false
    end
  end

  describe :active do
    it 'has an active status set at creation' do
      expect(build(:websocket).active).to be true
    end
  end

  describe :messages do
    it 'returns the right message if the URL is not given' do
      websocket = build(:websocket, url: nil)
      websocket.validate
      expect(websocket.errors.messages[:url]).to eq ['required']
    end
    it 'returns the right message if the URL is given in the wrong format' do
      websocket = build(:websocket, url: 'test')
      websocket.validate
      expect(websocket.errors.messages[:url]).to eq ['pattern']
    end
  end
end