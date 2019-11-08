module Arkaan
  module Concerns
    # Includes the MIME type field to files to ensure only supported types are included.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module MimeTypable
      extend ActiveSupport::Concern

      # Submodule holding all the static methods add to the current subclass.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      module ClassMethods
        # Defines the MIME type attribute with the given possible MIME types.
        # @param values [Array<String>] the possible MIME types, * can be used as wild cards.
        def mime_type(values)

          # @!attribute [rw] mime_type
          #   @return [String] the MIME type of the file, obtained from the uploaded file.
          field :mime_type, type: String
      
          validates :mime_type, presence: {message: 'required'}

          validate :mime_type_validity, if: :mime_type?

          # Validates the validity of the MIME type by checking if it respects any of the given mime types.
          # If it does not respect any MIME types possible, it adds an error to the mime_type field and invalidates.
          define_method :mime_type_validity do
            values.each do |type|
              type_regex = ::Regexp.new("^#{type.sub(/\*/, '(.+)')}$")
              return true if !type_regex.match(mime_type).nil?
            end
            errors.add(:mime_type, 'pattern')
          end
        end
      end
    end
  end
end