FactoryGirl.define do
  factory :empty_vigilante, class: Arkaan::Monitoring::Vigilante do
    factory :vigilante do
      token 'vigilante_token'
      key 'vigilante'
      path '/vigilante'
      diagnostic '/status'
    end
  end
end