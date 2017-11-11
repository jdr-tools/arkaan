FactoryGirl.define do
  factory :empty_session, class: Arkaan::Authentication::Session do
    factory :session do
      token 'session_token'
      association :account, factory: :account, strategy: :build

      factory :maintained_session do
        created_at DateTime.now
        expiration 3600
      end

      factory :not_maintained_session do
        created_at DateTime.now
        expiration 0
      end

      factory :expired_session do
        created_at DateTime.yesterday
        expiration 3600
      end
    end
  end
end