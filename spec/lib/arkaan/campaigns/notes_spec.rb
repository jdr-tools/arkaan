RSpec.describe Arkaan::Campaigns::Files::Note do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }

  describe 'content' do
    it 'has a content set at creation' do
      expect(build(:note, creator: account, campaign: campaign).content).to eq 'test de contenu'
    end
  end

  describe 'permissions' do
    let!(:player) { create(:account, username: 'First player', email: 'first@player.com') }
    let!(:other_player) { create(:account, username: 'Second player', email: 'second@player.com') }
    let!(:third_player) { create(:account, username: 'Third player', email: 'third@player.com') }

    let!(:player_invitation) { create(:accepted_invitation, account: player, campaign: campaign) }
    let!(:other_invitation) { create(:accepted_invitation, account: other_player, campaign: campaign) }
    let!(:third_invitation) { create(:accepted_invitation, account: third_player, campaign: campaign) }

    let!(:other_file) { create(:note, creator: player_invitation, campaign: campaign) }
    let!(:permission) { create(:file_permission, file: other_file, invitation: other_invitation) }

    it 'Correctly gives access to the file for the game master' do
      expect(other_file.is_allowed?(account)).to be true
    end
    it 'Correctly gives access to the file to the creator of the file' do
      expect(other_file.is_allowed?(player)).to be true
    end
    it 'Correctly gives access to the file for another player authorized to' do
      expect(other_file.is_allowed?(other_player)).to be true
    end
    it 'Correctly blocks the access of the file to a non-authorized player' do
      expect(other_file.is_allowed?(third_player)).to be false
    end
  end
end