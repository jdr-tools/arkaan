module Arkaan
  module Campaigns
    # Representation of a file, allowing us to retrieve it on AWS by its filename and linked campaign ID.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class File
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] filename
      #   @return [String] the name of the file, corresponding to the AWS name.
      field :name, type: String
      # @!attribute [rw] size
      #   @return [Integer] the size of the file in bytes.
      field :size, type: Integer, default: 0
      # @!attribute [rw] mime_type
      #   @return [String] the MIME type of the file, obtained from the uploaded file.
      field :mime_type, type: String

      # @!attribute [rw] invitation
      #   @return [Arkaan::Campaigns::Invitation] the link to the user creator of the file and the campaign it's created in.
      embedded_in :invitation, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :files

      validates 'name'     , presence: {message: 'required'}
      validates 'mime_type', presence: {message: 'required'}
    end
  end
end