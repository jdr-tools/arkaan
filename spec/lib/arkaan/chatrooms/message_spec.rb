RSpec.describe Arkaan::Chatrooms::Message do

  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }
  let!(:chatroom) { campaign.chatroom }

  describe 'text message' do
    let!(:message) { create(:text_message, account: account, chatroom: chatroom) }

    describe 'message attributes' do
      let!(:parsed_message) { campaign.messages.first }

      describe :content do
        it 'has the correct content' do
          expect(parsed_message.data).to eq({content: 'test'})
        end
      end

      describe :account do
        it 'has the correct account' do
          expect(parsed_message.account.username).to eq account.username
        end
      end

      describe :deleted do
        it 'has the correct default value when creating a message' do
          expect(parsed_message.deleted).to be false
        end
        it 'has the correct value when given to true' do
          deleted_message = create(:text_message, account: account, chatroom: chatroom, deleted: true)
          expect(deleted_message.deleted).to be true
        end
      end
    end
  end

  describe 'command message' do
    describe 'dice roll command' do
      let!(:message) { create(:diceroll, account: account, chatroom: chatroom) }

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

        describe :account do
          it 'has the correct account' do
            expect(parsed_message.account.username).to eq account.username
          end
        end
      end
    end
  end
end