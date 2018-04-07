RSpec.describe Arkaan::Campaigns::Tag do

  describe 'validity of a correctly built campaign tag' do
    it 'validates an campaign tag with all the parameters correctly given.' do
      expect(build(:campaign_tag).valid?).to be true
    end
  end

  describe :content do
    it 'has a content set at creation' do
      expect(build(:campaign_tag).content).to eq 'content_tag'
    end
    it 'does not validate the tag if the content is not given' do
      expect(build(:campaign_tag, content: nil).valid?).to be false
    end
    it 'does not validate the tag if the content is already used' do
      create(:campaign_tag)
      expect(build(:campaign_tag).valid?).to be false
    end
  end

  describe :count do
    it 'has a count set at creation' do
      expect(build(:campaign_tag, count: 10).count).to be 10
    end
    it 'has a default value if the count is not given' do
      expect(build(:campaign_tag).count).to be 1
    end
  end

  describe 'messages' do
    it 'returns the right message if the content is already used' do
      create(:campaign_tag)
      invalid_tag = build(:campaign_tag)
      invalid_tag.validate
      expect(invalid_tag.errors.messages[:content]).to eq(['uniq'])
    end
    it 'returns the right message if the content is not given' do
      invalid_tag = build(:campaign_tag, content: nil)
      invalid_tag.validate
      expect(invalid_tag.errors.messages[:content]).to eq(['required'])
    end
  end
end