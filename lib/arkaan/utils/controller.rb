module Arkaan
  module Utils
    # Base controller used in all services to handle general errors concerning the application and the gateway.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Controller < Sinatra::Base
      @@required_attributes = ['token', 'app_key']

      before do
        @parameters = JSON.parse(request.body.read.to_s) rescue {}

        check_required_attributes('token', 'app_key')
        @gateway = Arkaan::Monitoring::Gateway.where(token: @parameters['token']).first
        @application = Arkaan::OAuth::Application.where(key: @parameters['app_key']).first
        if @gateway.nil?
          halt 404, 'gateway_not_found'
        if @application.nil?
          halt 404, 'application_not_found'
        elsif !@application.premium?
          halt 401, 'application_not_authorized'
        end
      end

      # Checks a list of attributes for them to exist. If one attribute does not exist, the application halts.
      # @param {Array<String>} attributes - a list of attributes names to check the presence of.
      def check_required_attributes(*attributes)
        attributes.each do |attribute|
          if @parameters[attribute].nil? && params[attribute].nil?
            halt 400, {message: 'bad_request'}.to_json
          end
        end
      end
    end
  end
end