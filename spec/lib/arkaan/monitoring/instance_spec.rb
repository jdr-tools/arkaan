RSpec.describe Arkaan::Monitoring::Instance do
  describe :url do
    it 'has a url set at creation' do
      expect(build(:instance).url).to eq 'https://test-service.com/'
    end
    it 'invalidates the service if no URL is given' do
      expect(build(:instance, url: nil).valid?).to be false
    end
    it 'invalidates the service if the URL is given in a wrong format' do
      expect(build(:instance, url: 'test').valid?).to be false
    end
    it 'validates localhost URLs' do
      expect(build(:instance, url: 'http://localhost:3000/').valid?).to be true
    end
  end

  describe :service do
    it 'has a service set at creation' do
      expect(build(:instance, service: create(:service)).service.key).to eq 'test.service'
    end
  end

  describe :running do
    it 'has a running status set at creation' do
      expect(build(:instance).running).to be false
    end
  end

  describe :active do
    it 'has an active status set at creation' do
      expect(build(:instance).active).to be true
    end
  end

  describe :scopes do
    describe :running do
      let!(:service) { create(:service_with_running_instances) }

      it 'has a scope giving the currently running instances' do
        expect(service.instances.running.count).to be 1
      end
      it 'returns the currently running instances' do
        expect(service.instances.running.first.url).to eq 'https://test-service.com/'
      end
      it 'doesn\'t return the currently not running instances' do
        expect(create(:service_with_not_running_instances).instances.running.count).to be 0
      end
    end
    describe :active do
      let(:service) { create(:service_with_active_instances) }

      it 'has a scope giving the currently active instances' do
        expect(service.instances.active.count).to be 1
      end
      it 'returns the currently active instances' do
        expect(service.instances.active.first.url).to eq 'https://test-service.com/'
      end
    end
    describe :inactive do
      let(:service) { create(:service_with_inactive_instances) }

      it 'has a scope giving the currently inactive instances' do
        expect(service.instances.inactive.count).to be 1
      end
      it 'returns the currently inactive instances' do
        expect(service.instances.inactive.first.url).to eq 'https://test-service.com/'
      end
    end
  end

  describe :messages do
    it 'returns the right message if the URL is not given' do
      instance = build(:instance, url: nil)
      instance.validate
      expect(instance.errors.messages[:url]).to eq ['required']
    end
    it 'returns the right message if the URL is given in the wrong format' do
      instance = build(:instance, url: 'test')
      instance.validate
      expect(instance.errors.messages[:url]).to eq ['pattern']
    end
  end

  describe :actions do
    let!(:service) { create(:service) }
    let!(:instance) { create(:instance, service: service) }
    let!(:account) { create(:account) }
    let!(:action) { create(:action, instance: instance, user: account, type: :restart) }

    it 'has an action' do
      expect(instance.actions.count).to be 1
    end
    it 'has an action of the correct type' do
      expect(action.type).to be :restart
    end
    it 'has an action from the correct user' do
      expect(action.user.username).to eq 'Babausse'
    end
    it 'has an action on the correct instance' do
      expect(action.instance.url).to eq 'https://test-service.com/'
    end
  end
end