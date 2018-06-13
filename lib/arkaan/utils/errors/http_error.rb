module Arkaan
  module Utils
    module Errors
      # Standard class parent to all specialized http errors.
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      class HTTPError < StandardError

        # @!attribute [rw] field
        #   @return [String, Symbol] the name of the field in error in the model.
        attr_accessor :field
        # @!attribute [rw] action
        #   @return [String] the name of the action the user was trying to perform on the model (often crate or update).
        attr_accessor :action
        # @attribute [rw] error
        #   @return [String] the label of the error returned by the model.
        attr_accessor :error
        # @attribute [rw] status
        #   @return [Integer] the HTTP status code as a number (eg: 400, 422 or 500)
        attr_accessor :status

        def initialize (action, field, error, status)
          @action = action
          @field = field.to_s
          @error = error
          @status = status
        end
      end
    end
  end
end