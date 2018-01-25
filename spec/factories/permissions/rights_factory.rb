FactoryGirl.define do
  factory :empty_right, class: Arkaan::Permissions::Right do
    factory :right do
      slug 'test_right'
      association :category, factory: :category, strategy: :build

      factory :right_with_groups do
        after :create do |right, evaluator|
          create_list(:group, 1, rights: [right])
        end
      end
    end
  end
end