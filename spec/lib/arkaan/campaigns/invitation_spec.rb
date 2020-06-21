RSpec.describe Arkaan::Campaigns::Invitation do
  let!(:account) { create(:account) }
  let!(:other_account) { create(:account, username: 'Anything', email: 'test@test.com') }
  let!(:campaign) { create(:campaign, creator: other_account) }
  let!(:invitation) { create(:invitation, campaign: campaign, account: account, status: :pending) }

  describe :campaign do
    it 'has a campaign set at creation' do
      expect(invitation.campaign.title).to eq 'Test campaign'
    end
  end

  describe :history do
    describe 'When creating an invitation' do
      let!(:event) { invitation.history.first }

      it 'has an array with one element when creating the invitation' do
        expect(invitation.history.count).to be 1
      end
      it 'has created an history entry with the correct field' do
        expect(event.field).to eq 'enum_status'
      end
      it 'has created an history entry with the correct old value' do
        expect(event.from).to be_nil
      end
      it 'has created an history entry with the correct new value' do
        expect(event.to).to be :pending
      end
    end
    describe 'When updating the status' do
      let(:event) { invitation.history.last }
      before do
        invitation.update(enum_status: :accepted)
      end
      it 'adds an element to the history when modifying the status' do
        expect(invitation.history.count).to be 2
      end
      it 'adds the element with the correct field' do
        expect(event.field).to eq 'enum_status'
      end
      it 'adds the element with the correct old value' do
        expect(event.from).to eq :pending
      end
      it 'adds the element with the correct new value' do
        expect(event.to).to eq :accepted
      end
    end
    describe 'When updating the status twice' do
      let(:event) { invitation.history.last }
      before do
        invitation.update(enum_status: :accepted)
        invitation.update(enum_status: :expelled)
      end
      it 'adds an element to the history when modifying the status' do
        expect(invitation.history.count).to be 3
      end
      it 'adds the element with the correct field' do
        expect(event.field).to eq 'enum_status'
      end
      it 'adds the element with the correct old value' do
        expect(event.from).to eq :accepted
      end
      it 'adds the element with the correct new value' do
        expect(event.to).to eq :expelled
      end
    end
    describe 'When not changing the status at update' do
      before do
        invitation.update(enum_status: :pending)
      end
      it 'has not created a new element in the history' do
        expect(invitation.history.count).to be 1
      end
    end
  end

  describe :account do
    it 'has an account set at creation' do
      expect(invitation.account.username).to eq 'Babausse'
    end
  end
end