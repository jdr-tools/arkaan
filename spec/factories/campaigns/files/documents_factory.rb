FactoryGirl.define do
  factory :empty_document, class: Arkaan::Campaigns::Files::Document do
    factory :document do
      name 'file.txt'
      mime_type 'text/plain'
      size 30
    end
  end
end