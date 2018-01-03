ENV['SERVICE_URL'] = 'https://mon-service.com/'

RSpec.describe Arkaan::Utils::MicroService do

  describe :registered_service do
    describe 'When the service does not already exist' do
      before do
        Arkaan::Utils::MicroService.new(root: '/', name: 'test')
      end
      describe 'Service attributes' do
        let(:service) { Arkaan::Monitoring::Service.first }

        it 'correctly creates a service' do
          expect(Arkaan::Monitoring::Service.all.count).to be 1
        end
        it 'creates a service with the right key' do
          expect(service.key).to eq('test')
        end
        it 'creates a service with the right path' do
          expect(service.path).to eq('/test')
        end
        it 'creates a premium application' do
          expect(service.premium).to be true
        end
        it 'creates an active application' do
          expect(service.active).to be true
        end
      end
      describe 'Instance attributes' do
        let(:service) { Arkaan::Monitoring::Service.first }
        let(:instance) { service.instances.first }

        it 'correctly creates an instance for the service' do
          expect(service.instances.count).to be 1
        end
        it 'creates an instance with the right URL' do
          expect(instance.url).to eq('https://mon-service.com/')
        end
        it 'creates a running instance' do
          expect(instance.running).to be true
        end
        it 'creates an active instance' do
          expect(instance.active).to be true
        end
      end
    end
    describe 'When the service already exists but not the instance' do
      before do
        Arkaan::Monitoring::Service.create!(key: 'test', path: '/test', premium: true, active: true)
        Arkaan::Utils::MicroService.new(root: '/', name: 'test')
      end
      describe 'Service attributes' do
        it 'does not create another service' do
          expect(Arkaan::Monitoring::Service.all.count).to be 1
        end
      end
      describe 'Instance attributes' do
        let(:service) { Arkaan::Monitoring::Service.first }
        let(:instance) { service.instances.first }

        it 'correctly creates an instance for the service' do
          expect(service.instances.count).to be 1
        end
        it 'creates an instance with the right URL' do
          expect(instance.url).to eq 'https://mon-service.com/'
        end
        it 'creates a running instance' do
          expect(instance.running).to be true
        end
        it 'creates an active instance' do
          expect(instance.active).to be true
        end
      end
    end
    describe 'when the service and the instance already exist' do
      before do
        service = Arkaan::Monitoring::Service.create!(key: 'test', path: '/test', premium: true, active: true)
        Arkaan::Monitoring::Instance.create!(url: 'https://mon-service.com/', running: true, service: service, active: true)
      end
      describe 'Service attributes' do
        let(:service) { Arkaan::Monitoring::Service.first }

        it 'does not create another service' do
          expect(Arkaan::Monitoring::Service.all.count).to be 1
        end
      end
      describe 'Instance attributes' do
        let(:service) { Arkaan::Monitoring::Service.first }
        let(:instance) { service.instances.first }

        it 'does not create another instance for the service' do
          expect(service.instances.count).to be 1
        end
      end
    end
  end
end