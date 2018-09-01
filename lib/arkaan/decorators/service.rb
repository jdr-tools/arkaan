module Arkaan
  module Decorators
    # Decorator for a service, providing methods to make requests on it.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Service < Draper::Decorator
      delegate_all

      # Makes a POST request to the given service with the following steps :
      # 1. Gets an active and running instance of the service to make the request.
      # 2. Creates a Faraday connection to use it as a pipeline for the request.
      # 3. Makes the actual request and returns an object with the status and body of the response.
      #
      # @param route [String] the URL you want to reach on the service.
      # @param parameters [Hash] the additional parameters to pass in the JSON body.
      # @return [Hash, Boolean] FALSE if no instance are found, or an object with :status and :body keys correspding
      #                         to the status and body of the response to the request
      def post(route, parameters)
        instance = object.instances.where(active: true, running: true).first
        return false if instance.nil?
        connection = Faraday.new(instance.url) do
          faraday.request  :url_encoded
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end
        responde = connection.post do |req|
          req.url route
          req.headers['Content-Type'] = 'application/json'
          req.body = parameters.to_json
        end
        return {
          status: response.status,
          body: JSON.parse(response.body)
        }
      end
    end
  end
end