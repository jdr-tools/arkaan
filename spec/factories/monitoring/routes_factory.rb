FactoryGirl.define do
  factory :empty_route, class: Arkaan::Monitoring::Route do
    factory :route do
      path '/route'
      verb 'post'
      association :service, factory: :service, strategy: :build

      factory :premium_route do
        premium true
      end
      factory :inactive_route do
        active false
      end
    end
  end
end