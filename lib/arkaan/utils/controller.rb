module Arkaan
  module Utils
    # Base controller to handle the standard error when accessing the API.
    # @author Vincent Courtois <courtois.vincenet@outlook.com>
    class Controller < Sinatra::Base
      before do
        @parameters = JSON.parse(request.body.read.to_s) rescue {}
        if get_param('app_key').nil? || get_param('token').nil?
          halt 400, {message: 'bad_request'}.to_json
        end
        gateway = Arkaan::Monitoring::Gateway.where(token: get_param('token')).first
        application = Arkaan::OAuth::Application.where(key: get_param('app_key')).first
        if gateway.nil?
          halt 404, {message: 'gateway_not_found'}.to_json
        elsif application.nil?
          halt 404, {message: 'application_not_found'}.to_json
        elsif !application.premium?
          halt 401, {message: 'application_not_authorized'}.to_json
        end
      end

      # Gets a parameters from the parsed body hash, or the parsed querystring hash.
      # @param [String] key - the key of the parameter to get.
      # @return [any] the value associated with the key.
      def get_param(key)
        return (params.nil? || params[key].nil? ? @parameters[key] : params[key])
      end
    end
  end
end