RSpec.describe Arkaan::Campaigns::Character do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }
  let!(:invitation) { campaign.invitations.first }
  let!(:character) { create(:character, invitation: invitation, selected: true) }
  let!(:other_character) { create(:other_character, invitation: invitation) }

  describe :selected do
    it 'Has a default value set at creation' do
      expect(character.selected).to be true
    end
    it 'Has a value set by the user' do
      expect(other_character.selected).to be false
    end
  end
  describe :select! do
    before do
      other_character.select!
    end
    it 'Changes the selected flag for the selected character' do
      expect(Arkaan::Campaigns::Character.where(name: 'other_character.dnd4e').first.selected).to be true
    end
    it 'Changes the flag for the other character' do
      expect(Arkaan::Campaigns::Character.where(name: 'character.dnd4e').first.selected).to be false
    end
  end
  describe :mime_type do
    let!(:ruleset) { create(:ruleset, creator: account, mime_types: ['application/xml']) }
    let!(:campaign) { create(:campaign, title: 'test campagne ruleset', ruleset: ruleset, creator: account) }
    let!(:third_character) { build(:character, invitation: invitation, name: 'test.dnd4e') }

    it 'does not validate the sheet if the MIME type is not the correct one' do
      third_character.mime_type = 'text/plain'
      expect(third_character.valid?).to be false
    end
    it 'validates the sheet if the MIME type is correctly set' do
      third_character.mime_type = 'application/xml'
      expect(third_character.valid?).to be true
    end
  end
end