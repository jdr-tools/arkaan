RSpec.describe Arkaan::Campaigns::File do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }
  let!(:invitation) { campaign.invitations.first }
  let!(:file) { create(:file, creator: invitation, campaign: campaign) }

  describe :name do
    it 'has a name set at creation' do
      expect(file.name).to eq 'file.txt'
    end
    it 'fails to validate if the name is not given' do
      expect(build(:file, creator: invitation, name: nil).valid?).to be false
    end
  end

  describe :size do
    it 'has a size set at creation' do
      expect(file.size).to be 30
    end
  end

  describe :mime_type do
    it 'has a size MIME type at creation' do
      expect(file.mime_type).to eq 'text/plain'
    end
    it 'validates the MIME type if it\'s only respecting a RegExp and not the exact type' do
      expect(build(:file, creator: campaign.invitations.first, mime_type: 'image/png', campaign: campaign).valid?).to be true
    end
    it 'fails to validate if the MIME type is not given' do
      expect(build(:file, creator: campaign.invitations.first, mime_type: nil, campaign: campaign).valid?).to be false
    end
    it 'fails to validate if the MIME type is invalid' do
      expect(build(:file, creator: campaign.invitations.first, mime_type: 'anything', campaign: campaign).valid?).to be false
    end
  end

  describe 'permissions' do
    let!(:player) { create(:account, username: 'First player', email: 'first@player.com') }
    let!(:other_player) { create(:account, username: 'Second player', email: 'second@player.com') }
    let!(:third_player) { create(:account, username: 'Third player', email: 'third@player.com') }

    let!(:player_invitation) { create(:accepted_invitation, account: player, campaign: campaign) }
    let!(:other_invitation) { create(:accepted_invitation, account: other_player, campaign: campaign) }
    let!(:third_invitation) { create(:accepted_invitation, account: third_player, campaign: campaign) }

    let!(:other_file) { create(:file, creator: player_invitation, campaign: campaign) }
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

  describe 'errors.messages' do
    it 'returns the right message if the name is not given' do
      invalid_file = build(:file, creator: invitation, name: nil, campaign: campaign)
      invalid_file.validate
      expect(invalid_file.errors.messages[:name]).to eq(['required'])
    end
    it 'returns the right message if the MIME type is not given' do
      invalid_file = build(:file, creator: invitation, mime_type: nil, campaign: campaign)
      invalid_file.validate
      expect(invalid_file.errors.messages[:mime_type]).to eq(['required'])
    end
    it 'returns the right message if the MIME type is invalid' do
      invalid_file = build(:file, creator: invitation, mime_type: 'anything', campaign: campaign)
      invalid_file.validate
      expect(invalid_file.errors.messages[:mime_type]).to eq(['pattern'])
    end
  end
end