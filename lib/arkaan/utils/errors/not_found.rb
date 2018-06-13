module Arkaan
  module Utils
    module Errors
      # A not found error occurs when a user tries to reach a resource that does not exist.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class NotFound < Arkaan::Utils::Errors::HTTPError

        def initialize (field:, action:, error:)
          super(action, field, error, 404)
        end
      end
    end
  end
end