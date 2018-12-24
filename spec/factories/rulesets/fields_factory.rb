FactoryGirl.define do
  factory :empty_field, class: Arkaan::Rulesets::Field do
    factory :field do
      name 'test_field'
      type 'Integer'
    end
  end
end