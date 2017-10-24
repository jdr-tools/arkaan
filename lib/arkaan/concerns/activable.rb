module Arkaan
  module Concerns
    # Concerns for the objects that can be activated or deactivated, included the corresponding scopes.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Activable
      extend ActiveSupport::Concern

      included do
        # @!attribute [rw] active
        #   @return [Boolean] the active status of the instance, indicating if someone has deactivated it or not.
        field :active, type: Boolean, default: false
      
        scope :active  , ->{ where(active: true)  }
        scope :inactive, ->{ where(active: false) }
      end
    end
  end
end