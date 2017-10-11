FactoryGirl.define do
  factory :empty_application, class: Arkaan::OAuth::Application do
    factory :application do
      name :'My wonderful test application'
      association :creator, factory: :account, strategy: :build
    end
  end
end