FactoryGirl.define do
  factory :empty_gateway, class: Arkaan::Monitoring::Gateway do
    factory :gateway do
      url 'https://gateway.test/'
      diagnostic '/status'
    end
  end
end