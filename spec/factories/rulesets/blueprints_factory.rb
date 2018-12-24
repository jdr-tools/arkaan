FactoryGirl.define do
  factory :empty_blueprint, class: Arkaan::Rulesets::Blueprint do
    factory :blueprint do
      name 'test blueprint'
    end
  end
end