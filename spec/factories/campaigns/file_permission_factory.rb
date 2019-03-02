FactoryGirl.define do
  factory :empty_file_permission, class: Arkaan::Campaigns::Files::Permission do
    factory :file_permission do
      enum_level :read
    end
  end
end