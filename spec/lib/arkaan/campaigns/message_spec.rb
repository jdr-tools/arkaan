RSpec.describe Arkaan::Campaigns::Message do

  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }

  describe 'text message' do
    let!(:message) { create(:text_message, player: campaign.invitations.first, campaign: campaign) }

    describe 'message attributes' do
      let!(:parsed_message) { campaign.messages.first }

      describe :content do
        it 'has the correct content' do
          expect(parsed_message.data).to eq({content: 'test'})
        end
      end

      describe :player do
        it 'has the correct player' do
          expect(parsed_message.player.account.username).to eq account.username
        end
      end
    end
  end

  describe 'command message' do
    describe 'dice roll command' do
      let!(:message) { create(:diceroll, player: campaign.invitations.first, campaign: campaign) }

      describe 'message attributes' do
        let!(:parsed_message) { campaign.messages.first }

        describe :number_of_dices do
          it 'has the correct number of dices' do
            expect(parsed_message.data[:number_of_dices]).to eq 4
          end
        end

        describe :number_of_faces do
          it 'has the correct number of faces' do
            expect(parsed_message.data[:number_of_faces]).to eq 6
          end
        end

        describe :modifier do
          it 'has the correct modifier' do
            expect(parsed_message.data[:modifier]).to eq 5
          end
        end

        describe :results do
          it 'has the correct modifier' do
            expect(parsed_message.data[:results]).to eq [8, 2, 3, 1]
          end
        end

        describe :player do
          it 'has the correct player' do
            expect(parsed_message.player.account.username).to eq account.username
          end
        end
      end
    end
  end
end