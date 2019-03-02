FactoryGirl.define do
  factory :empty_note, class: Arkaan::Campaigns::Note do
    factory :note do
      content 'test de contenu'
    end
  end
end