FactoryGirl.define do
  factory :empty_categories, class: Arkaan::Rulesets::Sheets::Category do
    factory :sheet_category do
      name 'cat1'
    end
  end
end