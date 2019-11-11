RSpec.describe Arkaan::Campaigns::Files::Document do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }
  let!(:invitation) { campaign.invitations.first }
  let!(:document) { create(:document, creator: invitation) }

  describe :name do
    it 'has a name set at creation' do
      expect(document.name).to eq 'file.txt'
    end
    it 'fails to validate if the name is not given' do
      expect(build(:document, creator: invitation, name: nil).valid?).to be false
    end
  end

  describe :size do
    it 'has a size set at creation' do
      expect(document.size).to be 30
    end
  end

  describe :mime_type do
    it 'has a size MIME type at creation' do
      expect(document.mime_type).to eq 'text/plain'
    end
    it 'validates the MIME type if it\'s only respecting a RegExp and not the exact type' do
      expect(build(:document, creator: campaign.invitations.first, mime_type: 'image/png').valid?).to be true
    end
    it 'fails to validate if the MIME type is not given' do
      expect(build(:document, creator: campaign.invitations.first, mime_type: nil).valid?).to be false
    end
    it 'fails to validate if the MIME type is invalid' do
      expect(build(:document, creator: campaign.invitations.first, mime_type: 'anything').valid?).to be false
    end
  end

  describe 'permissions' do
    let!(:player) { create(:account, username: 'First player', email: 'first@player.com') }
    let!(:other_player) { create(:account, username: 'Second player', email: 'second@player.com') }
    let!(:third_player) { create(:account, username: 'Third player', email: 'third@player.com') }

    let!(:player_invitation) { create(:accepted_invitation, account: player, campaign: campaign) }
    let!(:other_invitation) { create(:accepted_invitation, account: other_player, campaign: campaign) }
    let!(:third_invitation) { create(:accepted_invitation, account: third_player, campaign: campaign) }

    let!(:other_document) { create(:document, creator: player_invitation) }
    let!(:permission) { create(:file_permission, document: other_document, invitation: other_invitation) }

    it 'Correctly gives access to the file for the game master' do
      expect(other_document.is_allowed?(account)).to be true
    end
    it 'Correctly gives access to the file to the creator of the file' do
      expect(other_document.is_allowed?(player)).to be true
    end
    it 'Correctly gives access to the file for another player authorized to' do
      expect(other_document.is_allowed?(other_player)).to be true
    end
    it 'Correctly blocks the access of the file to a non-authorized player' do
      expect(other_document.is_allowed?(third_player)).to be false
    end
  end

  describe 'errors.messages' do
    it 'returns the right message if the name is not given' do
      document = build(:document, creator: invitation, name: nil)
      document.validate
      expect(document.errors.messages[:name]).to eq(['required'])
    end
    it 'returns the right message if the MIME type is not given' do
      document = build(:document, creator: invitation, mime_type: nil)
      document.validate
      expect(document.errors.messages[:mime_type]).to eq(['required'])
    end
    it 'returns the right message if the MIME type is invalid' do
      document = build(:document, creator: invitation, mime_type: 'anything')
      document.validate
      expect(document.errors.messages[:mime_type]).to eq(['pattern'])
    end
  end
end