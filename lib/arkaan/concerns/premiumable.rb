module Arkaan
  module Concerns
    # Includes the premium field to make the entity including it accessible only to premium applications or not.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Premiumable
      extend ActiveSupport::Concern

      included do
        # @!attribute [rw] premium
        #   @return [Boolean] TRUE if the entity is made to be accessible only to premiuma pplications, FALSE otherwise.
        field :premium, type: Boolean, default: false
      end
    end
  end
end