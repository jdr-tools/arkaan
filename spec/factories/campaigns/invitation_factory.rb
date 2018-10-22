FactoryGirl.define do
  factory :empty_invitation, class: Arkaan::Campaigns::Invitation do
    factory :invitation do
      factory :creator_invitation do
        enum_status :creator
      end
    end
  end
end