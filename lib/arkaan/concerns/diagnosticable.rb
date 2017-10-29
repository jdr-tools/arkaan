module Arkaan
  module Concerns
    # Includes the diagnostic URL field, and the related validations.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Diagnosticable
      extend ActiveSupport::Concern

      # Module holding the class methods for the classes including this concern.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      module ClassMethods
        # Add the field and its validations in the model including it.
        # @param entity_type [String,Symbol] the name of the model including it, to be included in the error messages.
        def make_diagnosticable(entity_type)
          # @!attribute [rw] diagnostic
          #   @return [String] the diagnostic URL to know the status of an entity (usually a gateway, or an instance of a service).
          field :diagnostic, type: String, default: '/status'

          validates :diagnostic,
            presence: {message: "#{entity_type}.diagnostic.blank"},
            length: {minimum: 4, message: "#{entity_type}.diagnostic.short"},
            format: {with: /\A(\/[a-z]+)+\z/, message: "#{entity_type}.diagnostic.format"}
        end
      end
    end
  end
end