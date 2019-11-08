FactoryGirl.define do
  factory :empty_report, class: Arkaan::Monitoring::Results::Report do
    factory :report do
    end
  end
end