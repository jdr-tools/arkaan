module Arkaan
  module Campaigns
    # Representation of a file, allowing us to retrieve it on AWS by its filename and linked campaign ID.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class File
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] filename
      #   @return [String] the name of the file, corresponding to the AWS name.
      field :filename, type: String

      # @!attribute [rw] invitation
      #   @return [Arkaan::Campaigns::Invitation] the link to the user creator of the file and the campaign it's created in.
      embedded_in :invitation, class_name: 'Arkaan::Campaigns::Invitation', inverse_of: :files

      validates 'filename', presence: {message: 'required'}
    end
  end
end