module Arkaan
  module Utils
    # This class is a singleton to load and save parameters for the whole application.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class MicroService
      include Singleton

      # @!attribute [r] name
      #   @return [String] the name of the service you want to load.
      attr_reader :service
      # @!attribute [r] location
      #   @return [String] the path to the file loading the whole application, used to deduce the loading paths.
      attr_reader :location

      def initialize
        @location = false
        @service = false
      end

      # Determines if the application can be loaded (all the parameters have been correctly set)
      # @return [Boolean] TRUE if the application can be safely loaded, FALSE otherwise.
      def loadable?
        return !!(service && location)
      end

      # Getter for the path on which the service is mapped.
      # @return [String] the absolute path in the URL on which the service is mapped upon.
      def path
        return service ? service.path : false
      end

      # Getter for the name of the service.
      # @return [String] the name of the service as it is registered in the database.
      def name
        return service ? service.key : false
      end

      def register_as(service_name)
        @service = Arkaan::Monitoring::Service.where(key: service_name).first
        return self
      end

      def from_location(filename)
        @location = File.dirname(filename)
        return self
      end

      def load_app
        return self
      end

      def require_folder(folder)
        Dir[File.join(location, folder)].each do |filename|
          require filename
        end
      end

      # Registers a non premium route in the service, and in the controller of the application simultaneously
      # @param verb [String] the HTTP method of the route, can be GET, POST, PUT or DELETE.
      # @param path [String] the path of the route, must start with a /.
      def self.register_route(verb, path, &block)
        self.create_or_register_route(verb, path, false, &block)
      end

      # Registers a premium route in the service, and in the controller of the application simultaneously
      # @param verb [String] the HTTP method of the route, can be GET, POST, PUT or DELETE.
      # @param path [String] the path of the route, must start with a /.
      def self.register_premium_route(verb, path, &block)
        self.create_or_register_route(verb, path, true, &block)
      end

      def self.create_or_register_route(verb, path, premium, &block)
        if self.instance.loadable?
          route = self.instance.service.routes.where(verb: verb, path: path).first
          route = Arkaan::Monitoring::Route.create(verb: verb, path: path, premium: premium, service: service) if route.nil?
          self.instance.send(:verb, path, &block)
        end
      end
    end
  end
end