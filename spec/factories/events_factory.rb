FactoryGirl.define do
  factory :empty_event, class: Arkaan::Event do
    factory :status_event do
      field 'status'
    end
  end
end