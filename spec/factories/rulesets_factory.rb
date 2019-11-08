FactoryGirl.define do
  factory :empty_ruleset, class: Arkaan::Ruleset do
    factory :ruleset do
      name 'test ruleset'
      description 'description'
    end
  end
end