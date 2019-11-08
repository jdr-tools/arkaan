module Arkaan
  module Concerns
    # Includes the diagnostic URL field, and the related validations.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Diagnosticable
      extend ActiveSupport::Concern

      # Module holding the class methods for the classes including this concern.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      included do
        # @!attribute [rw] diagnostic
        #   @return [String] the diagnostic URL to know the status of an entity (usually a gateway, or an instance of a service).
        field :diagnostic, type: String, default: '/status'

        validates :diagnostic,
          presence: {message: "required"},
          length: {minimum: 4, message: "minlength"},
          format: {with: /\A(\/[a-z]+)+\z/, message: "pattern"}
      end
    end
  end
end