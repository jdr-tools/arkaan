FactoryGirl.define do
  factory :empty_websocket, class: Arkaan::Monitoring::Websocket do
    factory :websocket do
      url 'https://test-websocket.com/'
    end
  end
end