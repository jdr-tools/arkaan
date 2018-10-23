FactoryGirl.define do
  factory :empty_text_message, class: Arkaan::Campaigns::Message do
    factory :text_message do
      type :text
      data({content: 'test'})
    end
    factory :command do
      type :command
      factory :diceroll do
        data({
          command: 'diceroll',
          number_of_dices: 4,
          number_of_faces: 6,
          modifier: 5,
          results: [8, 2, 3, 1]
        })
      end
    end
  end
end