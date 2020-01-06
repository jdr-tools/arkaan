RSpec.describe Arkaan::Files::Document do
  let!(:babausse) { create(:account) }

  it 'validates a correctly built file' do
    expect(build(:file, creator: babausse).valid?).to be true
  end

  describe :name do
    it 'returns the name if given' do
      expect(build(:file, creator: babausse, name: 'test_name').name).to eq 'test_name'
    end
    it 'invalidates the file if the name is not given' do
      expect(build(:file, creator: babausse, name: nil).valid?).to be false
    end
    it 'invalidates the file if the name is already taken' do
      create(:file, name: 'test_name', creator: babausse)
      expect(build(:file, creator: babausse, name: 'test_name').valid?).to be false
    end
  end

  describe :extension do
    it 'returns the extension if given' do
      expect(build(:file, creator: babausse, extension: 'png').extension).to eq 'png'
    end
    it 'invalidates the extension if it is not given' do
      expect(build(:file, creator: babausse, extension: nil).valid?).to be false
    end
  end

  describe :size do
    it 'returns the size if given' do
      expect(build(:file, creator: babausse, size: 42).size).to be 42
    end
    it 'returns the correct size if not already given' do
      expect(build(:file, creator: babausse).size).to be 0
    end
  end

  describe :mime_type do
    it 'returns the MIME type if given' do
      expect(build(:file, creator: babausse).mime_type).to eq 'image/png'
    end
    it 'invalidates the file if the MIME type is not given' do
      expect(build(:file, creator: babausse, mime_type: nil).valid?).to be false
    end
  end

  describe :folder do
    it 'returns the folder if given' do
      expect(build(:file, creator: babausse, folder: '/directory').folder).to eq '/directory'
    end
    it 'returns the default folder if not given' do
      expect(build(:file, creator: babausse).folder).to eq '/'
    end
    it 'automatically adds the leading slash if not given' do
      expect(build(:file, creator: babausse, folder: 'directory').folder).to eq 'directory'
    end
    it 'invalidates the file if the folder is not given' do
      expect(build(:file, creator: babausse, folder: nil).valid?).to be false
    end
    it 'invalidates the file if the folder is in the wrong format' do
      expect(build(:file, creator: babausse, folder: '//directory').valid?).to be false
    end
  end

  describe :creator do
    it 'returns the creator if given' do
      expect(build(:file, creator: babausse).creator.username).to eq babausse.username
    end
    it 'invalidates the file if the creator is not given' do
      expect(build(:file, creator: nil).valid?).to be false
    end
  end

  describe 'errors.messages' do
    it 'name not given' do
      (file = build(:file, creator: babausse, name: nil)).validate
      expect(file.errors.messages[:name]).to eq ['required']
    end
    it 'name already taken' do
      create(:file, creator: babausse, name: 'test_name')
      (file = build(:file, creator: babausse, name: 'test_name')).validate
      expect(file.errors.messages[:name]).to eq ['uniq']
    end
    it 'extension not given' do
      (file = build(:file, creator: babausse, extension: nil)).validate
      expect(file.errors.messages[:extension]).to eq ['required']
    end
    it 'MIME type not given' do
      (file = build(:file, creator: babausse, mime_type: nil)).validate
      expect(file.errors.messages[:mime_type]).to eq ['required']
    end
    it 'folder not given' do
      (file = build(:file, creator: babausse, folder: nil)).validate
      expect(file.errors.messages[:folder]).to eq ['required']
    end
    it 'folder in wrong format' do
      (file = build(:file, creator: babausse, folder: '//directory')).validate
      expect(file.errors.messages[:folder]).to eq ['format']
    end
  end
end