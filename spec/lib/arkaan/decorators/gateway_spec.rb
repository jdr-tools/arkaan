RSpec.describe Arkaan::Decorators::Gateway do
  let(:account) { create(:account) }
  let!(:application) { create(:application, creator: account) }
  let!(:gateway) { create(:gateway) }
  let!(:decorator) { Arkaan::Decorators::Gateway.new('action', gateway) }
  let!(:session) { create(:session, account: account) }

  before :each do
    ENV['APP_KEY'] = 'test_app_key'
  end

  describe :post do
    it 'Returns an error when the ENV variable is nil' do
      ENV['APP_KEY'] = nil
      expect(->{ decorator.post(session: session, url: '/test', params: {}) }).to raise_error(Arkaan::Decorators::Errors::EnvVariableMissing)
    end
  end
end