RSpec.describe Arkaan::Campaigns::Messages::Diceroll do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }
  let!(:message) {
    create(:diceroll, {
      number_of_dices: 4,
      number_of_faces: 6,
      modifier: 5,
      player: campaign.invitations.first,
      campaign: campaign
    })
  }

  describe 'message attributes' do
    let!(:parsed_message) { campaign.messages.first }

    describe :number_of_dices do
      it 'has the correct number of dices' do
        expect(parsed_message.number_of_dices).to eq 4
      end
    end

    describe :number_of_faces do
      it 'has the correct number of faces' do
        expect(parsed_message.number_of_faces).to eq 6
      end
    end

    describe :modifier do
      it 'has the correct modifier' do
        expect(parsed_message.modifier).to eq 5
      end
    end

    describe :player do
      it 'has the correct player' do
        expect(parsed_message.player.account.username).to eq account.username
      end
    end

    describe :results do
      it 'has a result array of the correct size' do
        expect(parsed_message.results.count).to be 4
      end
      it 'has no result strictly above the number of faces' do
        selected = parsed_message.results.select { |result| result > parsed_message.number_of_faces }
        expect(selected.count).to be 0
      end
      it 'keeps the same results after saving it again' do
        results = parsed_message.results.clone
        parsed_message.save!
        expect(results).to eq parsed_message.results
      end
    end
  end
end