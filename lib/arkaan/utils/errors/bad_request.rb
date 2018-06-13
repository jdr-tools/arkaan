module Arkaan
  module Utils
    module Errors
      # A bad request error is raised when the data given to a model makes this model invalid.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class BadRequest < Arkaan::Utils::Errors::HTTPError

        def initialize(action:, field:, error:)
          super(action, field, error, 400)
        end
      end
    end
  end
end