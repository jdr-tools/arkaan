module Arkaan
  module Utils
    module Controllers
      # Base controller to handle the standard error when accessing the API.
      # @author Vincent Courtois <courtois.vincenet@outlook.com>
      class Checked < Arkaan::Utils::Controllers::Base

        before do
          before_checks
        end
      end
    end
  end
end