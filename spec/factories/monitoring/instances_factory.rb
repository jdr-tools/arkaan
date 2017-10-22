FactoryGirl.define do
  factory :empty_instance, class: Arkaan::Monitoring::Instance do
    factory :instance do
      url 'https://test-service.com/'
    end
  end
end