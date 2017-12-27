FactoryGirl.define do
  factory :empty_application, class: Arkaan::OAuth::Application do
    factory :application do
      name 'My wonderful test application'
      association :creator, factory: :account, strategy: :build

      factory :premium_application do
        key 'test_key'
        premium true
      end

      factory :not_premium_application do
        name 'Another test application'
        key 'other_key'
        premium false
      end

      factory :application_with_authorizations do
        after :create do |application, evaluator|
          create_list(:only_code_authorization, 1, application: application, account: create(:account))
        end
      end
    end
  end
end