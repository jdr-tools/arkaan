module Arkaan
  module Utils
    module Errors
      # A forbidden error occurs when a user tries to perform an action he's not allowed to.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class Forbidden < Arkaan::Utils::Errors::HTTPError

        def initialize (field:, action:, error:)
          super(action, field, error, 403)
        end
      end
    end
  end
end