FactoryGirl.define do
  factory :empty_application, class: Arkaan::OAuth::Application do
    factory :application do
      name :'My wonderful test application'
      association :creator, factory: :account, strategy: :build

      factory :application_with_authorizations do
        after :create do |application, evaluator|
          create_list(:only_code_authorization, 1, application: application, account: create(:account))
        end
      end
    end
  end
end