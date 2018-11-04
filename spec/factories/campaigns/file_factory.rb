FactoryGirl.define do
  factory :empty_file, class: Arkaan::Campaigns::File do
    factory :file do
      name 'file.txt'
      mime_type 'text/plain'
      size 30
    end
  end
end