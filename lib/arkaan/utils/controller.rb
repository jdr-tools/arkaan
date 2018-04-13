module Arkaan
  module Utils
    # Base controller to handle the standard error when accessing the API.
    # @author Vincent Courtois <courtois.vincenet@outlook.com>
    class Controller < Sinatra::Base
      register Sinatra::ConfigFile

      before do
        add_body_to_params
        check_presence('token', 'app_key')

        gateway = Arkaan::Monitoring::Gateway.where(token: params['token']).first
        @application = Arkaan::OAuth::Application.where(key: params['app_key']).first
        
        if gateway.nil?
          url = 'https://github.com/jdr-tools/arkaan/wiki/Errors#gateway-token-not-found'
          halt 404, {status: 404, field: 'token', error: 'unknown', docs: url}.to_json
        elsif @application.nil?
          url = 'https://github.com/jdr-tools/arkaan/wiki/Errors#application-key-not-found'
          halt 404, {status: 404, field: 'app_key', error: 'unknown', docs: url}.to_json
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
              url = 'https://github.com/jdr-tools/arkaan/wiki/Errors#application-not-premium'
              halt 403, {status: 403, field: 'app_key', error: 'forbidden', docs: url}.to_json
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
      def check_presence(*fields)
        fields.each do |field|
          if params[field].nil? || params[field] == ''
            url = 'https://github.com/jdr-tools/arkaan/wiki/Errors#parameter-not-given'
            halt 400, {status: 400, field: field, error: 'required', docs: url}.to_json
          end
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
        custom_error(400, "#{route}.#{}.#{messages[field].first}")
      end
    end
  end
end