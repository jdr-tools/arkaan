FactoryGirl.define do
  factory :empty_character, class: Arkaan::Campaigns::Character do
    factory :character do; end
    factory :other_character do; end
  end
end