FactoryGirl.define do
  factory :empty_access_token, class: Arkaan::OAuth::AccessToken do
    factory :random_access_token do
      expiration 3600
      association :authorization, factory: :authorization, strategy: :build

      factory :access_token do
        value 'test_access_token'
      end
    end
    factory :random_expiration_token do
      association :authorization, factory: :authorization, strategy: :build
      value 'test_access_token'
    end
  end
end