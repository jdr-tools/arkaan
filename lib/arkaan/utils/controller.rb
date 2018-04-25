module Arkaan
  module Utils
    # Base controller to handle the standard error when accessing the API.
    # @author Vincent Courtois <courtois.vincenet@outlook.com>
    class Controller < Sinatra::Base
      register Sinatra::ConfigFile

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

      # Creates a premium route whithin the Sinatra application, and registers it in the database if it does not already exists.
      # @param verb [String] the HTTP method used to create this route.
      # @param path [String] the path, beginning with a /, of the route to create.
      def self.declare_route(verb, path, &block)
        self.declare_route_with(verb, path, false, &block)
      end

      # Creates a non premium route whithin the Sinatra application, and registers it in the database if it does not already exists.
      # @param verb [String] the HTTP method used to create this route.
      # @param path [String] the path, beginning with a /, of the route to create.
      def self.declare_premium_route(verb, path, &block)
        self.declare_route_with(verb, path, true, &block)
      end

      # Creates a route whithin the Sinatra application, and registers it in the database if it does not already exists.
      # @param verb [String] the HTTP method used to create this route.
      # @param path [String] the path, beginning with a /, of the route to create.
      # @param premium [Boolean] TRUE to make the route premium, FALSE otherwise.
      def self.declare_route_with(verb, path, premium, &block)
        service = Arkaan::Utils::MicroService.instance.service
        unless service.nil? || !service.routes.where(path: path, verb: verb).first.nil?
          Arkaan::Monitoring::Route.create(path: path, verb: verb, premium: premium, service: service)
        end
        if premium
          self.public_send(verb, path) do
            @sinatra_route = parse_current_route
            if !@application.premium?
              custom_error(403, 'common.app_key.forbidden')
            end
            instance_eval(&block)
          end
        else
          self.public_send(verb, path, &block)
        end
      end

      # Loads the errors configuration file from the config folder.
      # @param file [String] send __FILE__
      def self.load_errors_from(file)
        config_file File.join(File.dirname(file), '..', 'config', 'errors.yml')
      end

      # Checks the presence of several fields given as parameters and halts the execution if it's not present.
      # @param fields [Array<String>] an array of fields names to search in the parameters
      def check_presence(*fields, route:)
        fields.each do |field|
          custom_error(400, "#{route}.#{field}.required") if params[field].nil? || params[field] == ''
        end
      end

      # Checks if the session ID is given in the parameters and if the session exists.
      # @param action [String] the action used to get the errors from the errors file.
      # @return [Arkaan::Authentication::Session] the session when it exists.
      def check_session(action)
        check_presence('session_id', route: action)
        session = Arkaan::Authentication::Session.where(token: params['session_id']).first
        if session.nil?
          custom_error(404, "#{action}.session_id.unknown")
        end
        return session
      end

      # Adds the parsed body to the parameters, overwriting the parameters of the querystring with the values
      # of the SON body if they have similar keys.
      def add_body_to_params
        parsed_body = JSON.parse(request.body.read.to_s) rescue {}
        parsed_body.keys.each do |key|
          params[key] = parsed_body[key]
        end
      end

      # Gets the current route in the database from the sinatra route.
      # @return [Arkaan::Monitoring::Route] the route declared in the services registry.
      def parse_current_route
        splitted = request.env['sinatra.route'].split(' ')
        return Arkaan::Monitoring::Route.where(verb: splitted.first.downcase, path: splitted.last).first
      end

      # Halts the application and creates the returned body from the parameters and the errors config file.
      # @param status [Integer] the HTTP status to halt the application with.
      # @param path [String] the path in the configuration file to access the URL.
      def custom_error(status, path)
        route, field, error = path.split('.')
        halt status, {status: status, field: field, error: error, docs: settings.errors[route][field][error]}.to_json
      end

      # Halts the application with a Bad Request error affecting a field of a model.
      # @param instance [Mongoid::Document] the document having a field in error.
      # @param route [String] the type of action you're currently doing (e.g: 'creation')
      def model_error(instance, route)
        messages = instance.errors.messages
        field = messages.keys.first
        custom_error(400, "#{route}.#{field}.#{messages[field].first}")
      end

      # Select parameters in the params hash, by its keys.
      # @param fields [Array<String>] the keys to select in the params hash.
      # @return [Hash] the selected chunk of the params hash.
      def select_params(*fields)
        return params.select { |key, value| fields.include?(key) }
      end

      def handle_arkaan_exception(exception)
        custom_error(exception.status, "#{exception.action}.#{exception.field}.#{exception.error}")
      end

      error Arkaan::Utils::Errors::BadRequest do |exception|
        handle_arkaan_exception(exception)
      end

      error Arkaan::Utils::Errors::Forbidden do |exception|
        handle_arkaan_exception(exception)
      end

      error Arkaan::Utils::Errors::NotFound do |exception|
        handle_arkaan_exception(exception)
      end
    end
  end
end