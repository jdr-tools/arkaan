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
  end
end