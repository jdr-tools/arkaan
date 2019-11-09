RSpec.describe Arkaan::Rulesets::Sheets::Attribute do
  let!(:account) { create(:account) }
  let!(:ruleset) { create(:ruleset, creator: account) }
  let!(:sheet) { create(:sheet, ruleset: ruleset, creator: account) }
  let!(:category) { create(:sheet_category, sheet: sheet) }
  describe :name do
    it 'has a name set at creation' do
      expect(build(:attribute, category: category).name).to eq 'ATTR'
    end
    it 'does not validate the attribute if the name is not given' do
      expect(build(:attribute, category: category, name: nil).valid?).to be false
    end
    it 'does not validate the attribute if the name has the wrong format' do
      expect(build(:attribute, category: category, name: 'test wrong').valid?).to be false
    end
    it 'does not validate the attribute if this name already exists in the same category' do
      create(:attribute, category: category)
      expect(build(:attribute, category: category).valid?).to be false
    end
    it 'does validate the attribute if this name only exists in another category' do
      other_cat = create(:sheet_category, sheet: sheet, name: 'cat2')
      create(:attribute, category: category)
      expect(build(:attribute, category: other_cat).valid?).to be true
    end
  end
end