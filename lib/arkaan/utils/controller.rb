module Arkaan
  module Utils
    # Base controller to handle the standard error when accessing the API.
    # @author Vincent Courtois <courtois.vincenet@outlook.com>
    class Controller < Sinatra::Base

      before do
        add_body_to_params
        check_presence('token', 'app_key')

        gateway = Arkaan::Monitoring::Gateway.where(token: params['token']).first
        application = Arkaan::OAuth::Application.where(key: params['app_key']).first

        if gateway.nil?
          halt 404, {message: 'gateway_not_found'}.to_json
        elsif application.nil?
          halt 404, {message: 'application_not_found'}.to_json
        elsif !application.premium?
          halt 401, {message: 'application_not_authorized'}.to_json
        end
      end

      # Checks the presence of several fields given as parameters and halts the execution if it's not present.
      # @param fields [Array<String>] an array of fields names to search in the parameters
      def check_presence(*fields)
        fields.each do |field|
          halt 400, {message: 'bad_request'}.to_json if params[field].nil?
        end
      end

      # Adds the parsed body to the parameters, overwriting the parameters of the querystring with the values
      # of the SON body if they have similar keys.
      def add_body_to_params
        parsed_body = JSON.parse(request.body.read.to_s) rescue {}
        parsed_body.keys.each do |key|
          params[key] = parsed_body[key]
        end
      end
    end
  end
end