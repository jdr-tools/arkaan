FactoryGirl.define do
  factory :empty_service, class: Arkaan::Monitoring::Service do
    factory :service do
      key 'test.service'
      path '/example'
      diagnostic '/status'

      factory :service_with_running_instances do
        key 'test.services.instances.running'
        after :create do |service, evaluator|
          service.instances << build(:instance, running: true)
        end
      end

      factory :service_with_not_running_instances do
        key 'test.services.instances.not_running'
        after :create do |service, evaluator|
          service.instances << build(:instance, running: false)
        end
      end

      factory :service_with_active_instances do
        key 'test.services.instances.active'
        after :create do |service, evaluator|
          service.instances << build(:instance, active: true)
        end
      end

      factory :service_with_inactive_instances do
        key 'test.services.instances.inactive'
        after :create do |service, evaluator|
          service.instances << build(:instance, active: false)
        end
      end

      factory :service_with_routes do
        key 'test.services.routes'
        after :create do |service, evaluator|
          service.routes << build(:route)
        end
      end

      factory :service_with_premium_routes do
        key 'test.services.routes'
        after :create do |service, evaluator|
          service.routes << build(:premium_route)
        end
      end
    end
  end
end