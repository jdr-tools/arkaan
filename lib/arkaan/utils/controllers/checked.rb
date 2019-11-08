module Arkaan
  module Utils
    module Controllers
      # Base controller to handle the standard error when accessing the API.
      # @author Vincent Courtois <courtois.vincenet@outlook.com>
      class Checked < Arkaan::Utils::Controllers::Base

        before do
          pass if route_is_diagnostic?
          before_checks
        end

        def route_is_diagnostic?
          service = Arkaan::Utils::MicroService.instance.service
          diagnostic = "#{service.path}#{service.diagnostic}"
          request.path_info == diagnostic
        end
      end
    end
  end
end