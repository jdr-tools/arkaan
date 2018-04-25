module Arkaan
  module Utils
    module Errors
      class BadRequest < StandardError
        attr_accessor :field

        attr_accessor :action

        attr_accessor :error

        def initialize(action:, field:, error:)
          @action = action
          @field = field
          @error = error
        end

        def status
          return 400
        end
      end
    end
  end
end