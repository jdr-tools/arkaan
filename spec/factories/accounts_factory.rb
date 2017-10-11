FactoryGirl.define do
  factory :empty_account, class: Arkaan::Account do
    factory :account do
      username  'Babausse'
      password  'password'
      firstname 'Vincent'
      lastname  'Courtois'
      email     'courtois.vincent@outlook.com'
      birthdate DateTime.new(2000, 1, 1)

      factory :conflicting_email_account do
        username 'Alternate User'
      end

      factory :conflicting_username_account do
        email 'alternate@email.com'
      end

      factory :account_with_groups do
        after :create do |account, evaluator|
          create_list(:group, 1, accounts: [account])
        end
      end
    end
  end
end