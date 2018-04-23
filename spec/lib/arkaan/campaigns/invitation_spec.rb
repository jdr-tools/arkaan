RSpec.describe Arkaan::Campaigns::Invitation do
  let!(:account) { create(:account) }
  let!(:other_account) { create(:account, username: 'Anything', email: 'test@test.com') }
  let!(:campaign) { create(:campaign, creator: other_account) }

  describe :campaign do
    it 'has a campaign set at creation' do
      expect(build(:invitation, campaign: campaign, account: account).campaign.title).to eq 'Test campaign'
    end
  end

  describe :status do
    describe 'accepted invitation' do
      let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :accepted) }
      it 'Has the correct accepted status' do
        expect(invitation.status).to eq(:accepted)
      end
    end
    describe 'expelled invitation' do
      let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :expelled) }
      it 'Has the correct expelled status' do
        expect(invitation.status).to eq(:expelled)
      end
    end
    describe 'ignored invitation' do
      let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :ignored) }
      it 'Has the correct ignored status' do
        expect(invitation.status).to eq(:ignored)
      end
    end
    describe 'pending invitation' do
      let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :pending) }
      it 'Has the correct pending status' do
        expect(invitation.status).to eq(:pending)
      end
    end
    describe 'refused invitation' do
      let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :refused) }
      it 'Has the correct refused status' do
        expect(invitation.status).to eq(:refused)
      end
    end
    describe 'unknown value' do
      let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :anything_else) }
      it 'Has the correct refused status' do
        expect(invitation.status).to eq(:pending)
      end
    end
  end

  describe :status_accepted do
    let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :pending) }

    it 'Sets the status' do
      invitation.status_accepted!
      expect(invitation.status).to be :accepted
    end
    it 'Returns true with the given accessor' do
      invitation.status_accepted!
      expect(invitation.status_accepted?).to be true
    end
  end

  describe :status_expelled do
    let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :pending) }

    it 'Sets the status' do
      invitation.status_expelled!
      expect(invitation.status).to be :expelled
    end
    it 'Returns true with the given accessor' do
      invitation.status_expelled!
      expect(invitation.status_expelled?).to be true
    end
  end

  describe :status_ignored do
    let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :pending) }

    it 'Sets the status' do
      invitation.status_ignored!
      expect(invitation.status).to be :ignored
    end
    it 'Returns true with the given accessor' do
      invitation.status_ignored!
      expect(invitation.status_ignored?).to be true
    end
  end

  describe :status_pending do
    let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :accepted) }

    it 'Sets the status' do
      invitation.status_pending!
      expect(invitation.status).to be :pending
    end
    it 'Returns true with the given accessor' do
      invitation.status_pending!
      expect(invitation.status_pending?).to be true
    end
  end

  describe :status_refused do
    let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :pending) }

    it 'Sets the status' do
      invitation.status_refused!
      expect(invitation.status).to be :refused
    end
    it 'Returns true with the given accessor' do
      invitation.status_refused!
      expect(invitation.status_refused?).to be true
    end
  end

  describe :account do
    it 'has an account set at creation' do
      expect(build(:invitation, campaign: campaign, account: account).account.username).to eq 'Babausse'
    end
  end
end