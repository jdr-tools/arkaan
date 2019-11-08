RSpec.describe Arkaan::Campaigns::Files::Character do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }
  let!(:invitation) { campaign.invitations.first }
  let!(:character) { create(:character, invitation: invitation, campaign: campaign, selected: true) }
  let!(:other_character) { create(:other_character, invitation: invitation, campaign: campaign) }

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
      expect(Arkaan::Campaigns::Files::Character.where(name: 'other_character.dnd4e').first.selected).to be true
    end
    it 'Changes the flag for the other character' do
      expect(Arkaan::Campaigns::Files::Character.where(name: 'character.dnd4e').first.selected).to be false
    end
  end
end