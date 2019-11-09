FactoryGirl.define do
  factory :empty_attribute, class: Arkaan::Rulesets::Sheets::Attribute do
    factory :attribute do
      name 'ATTR'
      default 0
      xpath 'anything'
    end
  end
end