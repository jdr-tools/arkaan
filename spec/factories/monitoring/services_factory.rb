FactoryGirl.define do
  factory :empty_service, class: Arkaan::Monitoring::Service do
    factory :service do
      key 'test.service'
      url 'https://test-service.com/'
      path '/example'
    end
  end
end