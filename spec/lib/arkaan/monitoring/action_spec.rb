RSpec.describe Arkaan::Monitoring::Action do
  let!(:service) { create(:service) }
  let!(:instance) { create(:instance, service: service) }
  let!(:account) { create(:account) }
  let!(:action) { build(:action, instance: instance, user: account) }

  describe :type do
    it 'invalidates the action if not given' do
      expect(action.valid?).to be false
    end
    it 'invalidates the action if given with a wrong value' do
      action.type = :anything
      expect(action.valid?).to be false
    end
    it 'validates the action if correctly given' do
      action.type = :restart
      expect(action.valid?).to be true
    end
  end
end