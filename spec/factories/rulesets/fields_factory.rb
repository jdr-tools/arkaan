FactoryGirl.define do
  factory :empty_field, class: Arkaan::Rulesets::Field do
    factory :integer_field, class: Arkaan::Rulesets::Fields::Integer do
      name 'test_field'
    end

    factory :gauge_field, class: Arkaan::Rulesets::Fields::Gauge do
      name 'test_field'
    end
  end
end