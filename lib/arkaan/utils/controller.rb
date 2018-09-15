module Arkaan
  module Utils
    # Base controller to handle the standard error when accessing the API.
    # @author Vincent Courtois <courtois.vincenet@outlook.com>
    class Controller < Arkaan::Utils::ControllerWithoutFilter

      before do
        before_checks
      end
    end
  end
end