module Arkaan
  module Decorators
    # Decorator for a service, providing methods to make requests on it.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Gateway < Draper::Decorator
      delegate_all

      # @!attribute [rw] action
      #   @return [String] the action of the route using this API.
      attr_accessor :action

      def initialize(action, _object)
        super(_object)
        @action = action
      end

      # Shortcut to make a DELETE request on the API.
      # @param session [Arkaan::Authentication::Session] the session of the user requesting the API.
      # @param url [String] the URL you want to reach on the service.
      # @param params [Hash] the additional parameters to pass in the JSON body.
      def delete(session:, url:, params:)
        return make_request_without_body(verb: 'delete', session: session, url: url, params: params)
      end

      # Shortcut to make a GET request on the API.
      # @param session [Arkaan::Authentication::Session] the session of the user requesting the API.
      # @param url [String] the URL you want to reach on the service.
      # @param params [Hash] the additional parameters to pass in the JSON body.
      def get(session:, url:, params:)
        return make_request_without_body(verb: 'get', session: session, url: url, params: params)
      end

      # Shortcut to make a POST request on the API.
      # @param session [Arkaan::Authentication::Session] the session of the user requesting the API.
      # @param url [String] the URL you want to reach on the service.
      # @param params [Hash] the additional parameters to pass in the JSON body.
      def post(session:, url:, params:)
        return make_request(verb: 'post', session: session, url: url, params: params)
      end

      # Shortcut to make a PUT request on the API.
      # @param session [Arkaan::Authentication::Session] the session of the user requesting the API.
      # @param url [String] the URL you want to reach on the service.
      # @param params [Hash] the additional parameters to pass in the JSON body.
      def put(session:, url:, params:)
        return make_request(verb: 'put', session: session, url: url, params: params)
      end

      private

      # Makes a POST request to the given service with the following steps :
      # 1. Gets an active and running instance of the service to make the request.
      # 2. Creates a Faraday connection to use it as a pipeline for the request.
      # 3. Makes the actual request and returns an object with the status and body of the response.
      #
      # @param verb [String] the HTTP verb to use for this request.
      # @param session [Arkaan::Authentication::Session] the session of the user requesting the API.
      # @param url [String] the URL you want to reach on the service.
      # @param params [Hash] the additional parameters to pass in the JSON body.
      #
      # @return [Hash, Boolean] FALSE if no instance are found, or an object with :status and :body keys correspding
      #                         to the status and body of the response to the request
      def make_request(verb:, session:, url:, params:)
        params = before_requests(session, params)
        connection = get_connection
        response = connection.send(verb) do |req|
          req.url url
          req.headers['Content-Type'] = 'application/json'
          req.body = params.to_json
        end

        return {
          status: response.status,
          body: JSON.parse(response.body)
        }
      end

      def make_request_without_body(verb:, session:, url:, params:)
        params = before_requests(session, params)
        connection = get_connection
        response = connection.send(verb) do |req|
          req.url url, params
          req.headers['Content-Type'] = 'application/json'
        end
      end

      def before_requests(session, params)
        if ENV['APP_KEY'].nil?
          raise Arkaan::Decorators::Errors::EnvVariableMissing.new(action: action)
        end
        params[:app_key] = ENV['APP_KEY']
        params[:session_id] = session.token
        return params
      end

      def get_connection
        Faraday.new(object.url) do |faraday|
          faraday.request  :url_encoded
          faraday.response :logger
          faraday.adapter  Faraday.default_adapter
        end
      end
    end
  end
end