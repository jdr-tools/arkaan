RSpec.shared_examples 'diagnostic' do |item, value|

  describe :diagnostic do
    it "returns the correct diagnostic URL for a given #{item.to_s}" do
      expect(build(item).diagnostic).to eq value
    end
    it "invalidates the #{item.to_s} if the diagnostic URL is not given" do
      expect(build(item, diagnostic: nil).valid?).to be false
    end
    it "invalidates the #{item.to_s} if the diagnostic URL is less than four characters" do
      expect(build(item, diagnostic: 'no').valid?).to be false
    end
    it "invalidates the #{item.to_s} if the diagnostic URL is given with a wrong format" do
      expect(build(item, diagnostic: 'strangeFormatForASlug').valid?).to be false
    end
  end
end