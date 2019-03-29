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
      campaign = create(:campaign, creator: account)
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

  describe :max_players do
    it 'has a max number of players set at creation' do
      expect(build(:campaign, max_players: 10).max_players).to be 10
    end
    it 'has a default max number of players' do
      expect(build(:campaign).max_players).to be 5
    end
    it 'cannot have a max number of players below 1' do
      expect(build(:campaign, creator: account, max_players: 0).valid?).to be false
    end
    it 'cannot have a max number of players above 20' do
      expect(build(:campaign, creator: account, max_players: 21).valid?).to be false
    end
  end

  describe 'errors.messages' do
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
    it 'returns the right message if the max_players is below 1' do
      invalid_campaign = build(:campaign, creator: account, max_players: 0)
      invalid_campaign.validate
      expect(invalid_campaign.errors.messages[:max_players]).to eq(['minimum'])
    end
    it 'returns the right message if the max_players is above 20' do
      invalid_campaign = build(:campaign, creator: account, max_players: 21)
      invalid_campaign.validate
      expect(invalid_campaign.errors.messages[:max_players]).to eq(['maximum'])
    end
  end
end