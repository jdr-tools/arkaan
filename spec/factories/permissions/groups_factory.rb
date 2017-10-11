FactoryGirl.define do
  factory :empty_group, class: Arkaan::Permissions::Group do
    factory :group do
      slug 'test_group'

      factory :group_with_members do
        after :create do |group, evaluator|
          create_list(:account, 1, groups: [group])
        end
      end

      factory :group_with_rights do
        after :create do |group, evaluator|
          create_list(:right, 1, groups: [group])
        end
      end
    end
  end
end