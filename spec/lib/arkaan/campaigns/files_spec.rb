RSpec.describe Arkaan::Campaigns::File do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }
  let!(:file) { build(:file, invitation: campaign.invitations.first) }

  describe :name do
    it 'has a name set at creation' do
      expect(file.name).to eq 'file.txt'
    end
    it 'fails to validate if the name is not given' do
      expect(build(:file, invitation: campaign.invitations.first, name: nil).valid?).to be false
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
      expect(build(:file, invitation: campaign.invitations.first, mime_type: 'image/png').valid?).to be true
    end
    it 'fails to validate if the MIME type is not given' do
      expect(build(:file, invitation: campaign.invitations.first, mime_type: nil).valid?).to be false
    end
    it 'fails to validate if the MIME type is invalid' do
      expect(build(:file, invitation: campaign.invitations.first, mime_type: 'anything').valid?).to be false
    end
  end

  describe 'errors.messages' do
    it 'returns the right message if the name is not given' do
      invalid_file = build(:file, invitation: campaign.invitations.first, name: nil)
      invalid_file.validate
      expect(invalid_file.errors.messages[:name]).to eq(['required'])
    end
    it 'returns the right message if the MIME type is not given' do
      invalid_file = build(:file, invitation: campaign.invitations.first, mime_type: nil)
      invalid_file.validate
      expect(invalid_file.errors.messages[:mime_type]).to eq(['required'])
    end
    it 'returns the right message if the MIME type is invalid' do
      invalid_file = build(:file, invitation: campaign.invitations.first, mime_type: 'anything')
      invalid_file.validate
      expect(invalid_file.errors.messages[:mime_type]).to eq(['pattern'])
    end
  end
end