FactoryGirl.define do
  factory :empty_document, class: Arkaan::Files::Document do
    factory :file do
      name { Faker::Games::LeagueOfLegends.location }
      extension 'png'
      mime_type 'image/png'
    end
  end
end