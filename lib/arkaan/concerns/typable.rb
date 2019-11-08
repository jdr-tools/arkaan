module Arkaan
  module Concerns
    # Concerns for the objects that can be activated or deactivated, included the corresponding scopes.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Typable
      extend ActiveSupport::Concern

      included do
        include Arkaan::Concerns::Enumerable
        
        # @!attribute [rw] type
        #   @return [Symbol] the type of the instance, determining its way of being deployed, restarted, etc.
        enum_field :type, [:heroku, :local, :unix], default: :heroku
      end
    end
  end
end