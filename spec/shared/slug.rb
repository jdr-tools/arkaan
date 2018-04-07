RSpec.shared_examples 'slug' do |item, value|

  describe :slug do
    describe 'Valid slug' do
      it "returns the correct slug for a given #{item.to_s}" do
        expect(build(item).slug).to eq value
      end
    end
    describe 'when the slug is already taken' do
      let!(:already_existing) { create(item) }
      it "invalidates the #{item.to_s} if the slug is already taken" do
        expect(build(item).valid?).to be false
      end
      it 'returns the correct message when the slug is already taken' do
        new_item = build(item)
        new_item.validate
        expect(new_item.errors.messages).to eq({slug: ['uniq']})
      end
    end
    describe 'when the slug is not given' do
      it "invalidates the #{item.to_s} if the slug is not given" do
        expect(build(item, slug: nil).valid?).to be false
      end
      it 'returns the correct message when the slug is not given' do
        new_item = build(item, slug: nil)
        new_item.validate
        expect(new_item.errors.messages).to eq({slug: ['required']})
      end
    end
    describe 'when the slug is less than four characters' do
      it "invalidates the #{item.to_s} if the slug is less than four characters" do
        expect(build(item, slug: 'no').valid?).to be false
      end
      it 'returns the correct message when the slug is less than four characters' do
        new_item = build(item, slug: 'no')
        new_item.validate
        expect(new_item.errors.messages).to eq({slug: ['minlength']})
      end
    end
    describe 'when the slug is in the wrong format' do
      it "invalidates the #{item.to_s} if the slug is given with a wrong format" do
        expect(build(item, slug: 'strangeFormatForASlug').valid?).to be false
      end
      it 'returns the correct message when the slug is in the wrong format' do
        new_item = build(item, slug: 'strangeFormatForASlug')
        new_item.validate
        expect(new_item.errors.messages).to eq({slug: ['pattern']})
      end
    end
  end
end