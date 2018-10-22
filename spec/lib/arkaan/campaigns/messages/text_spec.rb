RSpec.describe Arkaan::Campaigns::Messages::Text do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }
  let!(:message) { create(:text_message, content: 'test', player: campaign.invitations.first, campaign: campaign) }

  describe 'message attributes' do
    let!(:parsed_message) { campaign.messages.first }

    describe :content do
      it 'has the correct content' do
        expect(parsed_message.content).to eq 'test'
      end
    end

    describe :player do
      it 'has the correct player' do
        expect(parsed_message.player.account.username).to eq account.username
      end
    end
  end
end