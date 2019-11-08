module Arkaan
  module Campaigns
    module Files
      # Representation of a file, allowing us to retrieve it on AWS by its filename and linked campaign ID.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Document < Arkaan::Campaigns::Files::Base
        include Arkaan::Concerns::MimeTypable
        include Arkaan::Campaigns::Files::Concerns::Nameable

        # @!attribute [rw] size
        #   @return [Integer] the size of the file in bytes.
        field :size, type: Integer, default: 0

        mime_type ['image/*', 'text/plain']
      end
    end
  end
end