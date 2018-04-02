RSpec.describe Arkaan::Campaigns::Invitation do
  let!(:account) { create(:account) }
  let!(:other_account) { create(:account, username: 'Anything', email: 'test@test.com') }
  let!(:campaign) { create(:campaign, creator: other_account) }

  describe :campaign do
    it 'has a campaign set at creation' do
      expect(build(:invitation, campaign: campaign, account: account, creator: other_account).campaign.title).to eq 'Test campaign'
    end
  end

  describe :accepted do
    it 'has a default value for the accepted flag' do
      expect(build(:invitation, campaign: campaign, account: account, creator: other_account).accepted).to be false
    end
    it 'returns the correct value for the accepted flag' do
      expect(build(:invitation, campaign: campaign, account: account, accepted: true, creator: other_account).accepted).to be true
    end
  end

  describe :accepted_at do
    it 'can have a date of acceptation' do
      date = DateTime.now
      invitation = build(:invitation, campaign: campaign, account: account, creator: other_account, accepted_at: date)
      expect(invitation.accepted_at).to eq date
    end
    it 'returns nil if the accepted_at datetime has not been set' do
      invitation = build(:invitation, campaign: campaign, account: account, creator: other_account)
      expect(invitation.accepted_at).to be nil
    end
  end

  describe :account do
    it 'has an account set at creation' do
      expect(build(:invitation, campaign: campaign, account: account, creator: other_account).account.username).to eq 'Babausse'
    end
  end
end