RSpec.describe Arkaan::Campaign do

  let!(:account) { create(:account) }

  describe 'validity of a correctly built campaign' do
    it 'validates a correctly built campaign' do
      expect(build(:campaign, creator: account).valid?).to be true
    end
  end

  describe :title do
    it 'has a title set at creation' do
      expect(build(:campaign, creator: account).title).to eq 'Test campaign'
    end
    it 'fails to build a campaign if the title of the campaign is not given' do
      expect(build(:campaign, title: nil, creator: account).valid?).to be false
    end
    it 'fails to build a campaign if the name of the campaign is less than four characters' do
      expect(build(:campaign, title: 'a', creator: account).valid?).to be false
    end
    it 'fails to build a campaign if the user already has a campaign with the same title' do
      create(:campaign, creator: account)
      expect(build(:campaign, creator: account).valid?).to be false
    end
  end

  describe :is_private do
    it 'has a privacy set at creation' do
      expect(build(:campaign, creator: account).is_private).to be true
    end
  end

  describe :description do
    it 'has a description set at creation' do
      expect(build(:campaign, creator: account).description).to eq 'Description of test campaign'
    end
  end

  describe :tags do
    it 'has a list of tag set empty at creation' do
      expect(build(:campaign, creator: account).tags).to eq []
    end
    it 'is able to insert a new tag in the tag list' do
      campaign = build(:campaign, creator: account)
      campaign.tags << 'test_tag'
      expect(campaign.tags).to eq ['test_tag']
    end
    it 'is possible to set the tags at creation' do
      expect(build(:campaign, tags: ['test_tag'], creator: account).tags).to eq ['test_tag']
    end
  end

  describe :messages do
    it 'returns the right message if the title is not given' do
      invalid_campaign = build(:campaign, title: nil, creator: account)
      invalid_campaign.validate
      expect(invalid_campaign.errors.messages[:title]).to eq(['required'])
    end
    it 'returns the right message if the title is less than four characters' do
      invalid_campaign = build(:campaign, title: 'a', creator: account)
      invalid_campaign.validate
      expect(invalid_campaign.errors.messages[:title]).to eq(['minlength'])
    end
    it 'returns the right message if the title is already used by this user' do
      create(:campaign, creator: account)
      invalid_campaign = build(:campaign, creator: account)
      invalid_campaign.validate
      expect(invalid_campaign.errors.messages[:title]).to eq(['uniq'])
    end
  end
end