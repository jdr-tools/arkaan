RSpec.describe Arkaan::Campaigns::File do
  let!(:account) { create(:account) }
  let!(:campaign) { create(:campaign, creator: account) }

  describe :filename do
    it 'has a filename set at creation' do
      expect(build(:file, invitation: campaign.invitations.first, filename: 'test_filename').filename).to eq 'test_filename'
    end
    it 'fails to validate if the filename is not given' do
      expect(build(:file, invitation: campaign.invitations.first, filename: nil).valid?).to be false
    end
  end

  describe 'errors.messages' do
    it 'returns the right message if the filename is not given' do
      invalid_file = build(:file, invitation: campaign.invitations.first, filename: nil)
      invalid_file.validate
      expect(invalid_file.errors.messages[:filename]).to eq(['required'])
    end
  end
end