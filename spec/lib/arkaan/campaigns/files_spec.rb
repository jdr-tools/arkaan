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

  describe :mim_type do
    it 'has a size MIME type at creation' do
      expect(file.mime_type).to eq 'text/plain'
    end
    it 'fails to validate if the name is not given' do
      expect(build(:file, invitation: campaign.invitations.first, mime_type: nil).valid?).to be false
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
  end
end