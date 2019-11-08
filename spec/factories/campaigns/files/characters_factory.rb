FactoryGirl.define do
  factory :empty_character, class: Arkaan::Campaigns::Files::Character do
    mime_type 'application/xml'
    factory :character do
      name 'character.dnd4e'
    end
    factory :other_character do
      name 'other_character.dnd4e'
    end
  end
end