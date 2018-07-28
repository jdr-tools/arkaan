module Arkaan
  module Utils
    # Base controller to handle the standard error when accessing the API.
    # @author Vincent Courtois <courtois.vincenet@outlook.com>
    class Controller < Arkaan::Utils::ControllerWithoutFilter

      before do
        add_body_to_params
        check_presence('token', 'app_key', route: 'common')

        gateway = Arkaan::Monitoring::Gateway.where(token: params['token']).first
        @application = Arkaan::OAuth::Application.where(key: params['app_key']).first
        
        if gateway.nil?
          custom_error(404, 'common.token.unknown')
        elsif @application.nil?
          custom_error(404, 'common.app_key.unknown')
        end
      end
    end
  end
end