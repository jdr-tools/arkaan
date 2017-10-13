FactoryGirl.define do
  factory :empty_authorization, class: Arkaan::OAuth::Authorization do

    factory :only_code_authorization do
      code 'test_code'
    end

    factory :authorization_random_code do

      association :account, factory: :account, strategy: :build
      association :application, factory: :application, strategy: :build
      
      factory :authorization do
        code 'test_code'
      end
    end
  end
end