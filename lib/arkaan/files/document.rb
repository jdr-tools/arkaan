module Arkaan
  module Files
    # a document is an uploaded file in the S3 clone application.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Document
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] name
      #   @return [String] the filename the user entered when uploading the file.
      field :name, type: String

      field :extension, type: String
      # @!attribute [rw] size
      #   @return [String] the size, in bytes, of the uploaded file.
      field :size, type: Integer, default: 0
      # @!attribute [rw] folder
      #   @return [String] the folder in which the file is stored in the S3 clone.
      field :folder, type: String, default: '/'
      # @!attribute [rw] mime_type
      #   @return [String] the MIME type of the file. this MAY not correspond to the real
      #     MIME type of the uploaded file, this is just an indication.
      field :mime_type, type: String

      # @!attribute [rw] creator
      #   @return [Arkaan::Account] the account of the person that uploaded the file.
      belongs_to :creator, class_name: 'Arkaan::Account', inverse_of: :files

      # @!attribute [rw] permissions
      #   @return [Array<Arkaan::Files::Permission>] the permissions granted to access this file.
      has_many :permissions, class_name: 'Arkaan::Files::Permission', inverse_of: :file

      validates :name, :extension, :folder, :mime_type, presence: {message: 'required'}

      validates :folder, format: {without: /\/\//, message: 'format'}

      validate :filename_unicity

      def filename_unicity
        existing = Arkaan::Files::Document.where(
          name: name,
          folder: folder,
          extension: extension,
          :id.ne => id
        )
        errors.add(:name, 'uniq') unless existing.first.nil?
      end
    end
  end
end