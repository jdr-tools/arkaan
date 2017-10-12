FactoryGirl.define do
  factory :empty_refresh_token, class: Arkaan::OAuth::RefreshToken do
    factory :refresh_token do
      value 'test_refresh_token'
    end
  end
end