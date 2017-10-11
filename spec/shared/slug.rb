RSpec.shared_examples 'slug' do |item, value|

  describe :slug do
    it "returns the correct slug for a given #{item.to_s}" do
      expect(build(item).slug).to eq value
    end
    it "invalidates the #{item.to_s} if the slug is already taken" do
      create(item)
      expect(build(item).valid?).to be false
    end
    it "invalidates the #{item.to_s} if the slug is not given" do
      expect(build(item, slug: nil).valid?).to be false
    end
    it "invalidates the #{item.to_s} if the slug is less than four characters" do
      expect(build(item, slug: 'no').valid?).to be false
    end
    it "invalidates the #{item.to_s} if the slug is given with a wrong format" do
      expect(build(item, slug: 'strangeFormatForASlug').valid?).to be false
    end
  end
end