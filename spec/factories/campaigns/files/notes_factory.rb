FactoryGirl.define do
  factory :empty_note, class: Arkaan::Campaigns::Files::Note do
    factory :note do
      content 'test de contenu'
    end
  end
end