module Arkaan
  module Utils
    # Base controller to handle the standard error when accessing the API.
    # @author Vincent Courtois <courtois.vincenet@outlook.com>
    class ControllerWithoutFilter < Sinatra::Base
      register Sinatra::ConfigFile
      helpers Sinatra::CustomLogger

      configure do
        set :logger, Logger.new(STDOUT)
        logger.level = Logger::ERROR if ENV['RACK_ENV'] == 'test'
      end

      # Creates a premium route whithin the Sinatra application, and registers it in the database if it does not already exists.
      # @param verb [String] the HTTP method used to create this route.
      # @param path [String] the path, beginning with a /, of the route to create.
      def self.declare_route(verb, path, options: {}, &block)
        self.declare_route_with(verb, path, false, options, &block)
      end

      # Creates a non premium route whithin the Sinatra application, and registers it in the database if it does not already exists.
      # @param verb [String] the HTTP method used to create this route.
      # @param path [String] the path, beginning with a /, of the route to create.
      def self.declare_premium_route(verb, path, options: {}, &block)
        self.declare_route_with(verb, path, true, options, &block)
      end

      # Creates a route whithin the Sinatra application, and registers it in the database if it does not already exists.
      # @param verb [String] the HTTP method used to create this route.
      # @param path [String] the path, beginning with a /, of the route to create.
      # @param premium [Boolean] TRUE to make the route premium, FALSE otherwise.
      def self.declare_route_with(verb, path, premium, options, &block)
        service = Arkaan::Utils::MicroService.instance.service
        complete_path = "#{Arkaan::Utils::MicroService.instance.path}#{path == '/' ? '' : path}"

        unless service.nil? || !service.routes.where(path: path, verb: verb).first.nil?
          route = Arkaan::Monitoring::Route.create(path: path, verb: verb, premium: premium, service: service)
          if !options.nil? && !options[:authenticated].nil?
            route.update_attribute(:authenticated, false)
          end
          Arkaan::Permissions::Group.where(is_superuser: true).each do |group|
            group.routes << route
            group.save!
          end
        end
        if premium
          self.public_send(verb, complete_path) do
            @sinatra_route = parse_current_route
            if !@application.premium?
              custom_error(403, 'common.app_key.forbidden')
            end
            instance_eval(&block)
          end
        else
          logger.info "#{verb} #{complete_path}"
          self.public_send(verb, complete_path, &block)
        end
      end

      # Loads the errors configuration file from the config folder.
      # @param file [String] send __FILE__
      def self.load_errors_from(file)
        config_file File.join(File.dirname(file), '..', 'config', 'errors.yml')
      end

      def before_checks
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

      # Checks the presence of several fields given as parameters and halts the execution if it's not present.
      # @param fields [Array<String>] an array of fields names to search in the parameters
      # @param route [String] the name of the route you're requiring to put in the error message.
      def check_presence(*fields, route:)
        fields.each do |field|
          custom_error(400, "#{route}.#{field}.required") if params[field].nil? || params[field] == ''
        end
      end

      # Checks the presence of either fields given in parameters. It halts with an error only if ALL parameters are not given.
      # @param fields [Array<String>] an array of fields names to search in the parameters
      # @param route [String] the name of the route you're requiring to put in the error message.
      # @param key [String] the key to search in the errors configuration file.
      def check_either_presence(*fields, route:, key:)
        fields.each do |field|
          return true if !params[field].nil? && params[field] != ''
        end
        custom_error 400, "#{route}.#{key}.required"
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

      def check_application(action)
        check_presence('app_key', route: action)
        application = Arkaan::OAuth::Application.where(key: params['app_key']).first
        custom_error(404, "#{action}.app_key.unknown") if application.nil?
        return application
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
        docs = settings.errors[route][field][error] rescue ''
        halt status, {status: status, field: field, error: error, docs: docs}.to_json
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

      # Creates a custom error from an existing Arkaan exception class.
      # @param exception {StandardError} the exception to transform in a usable error.
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

      error Arkaan::Factories::Errors::GatewayNotFound do |exception|
        handle_arkaan_exception(exception)
      end

      error StandardError do |exception|
        custom_error(500, 'system_error.unknown_field.unknown_error')
      end
    end
  end
end