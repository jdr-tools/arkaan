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
      # @!attribute [r] name
      #   @return [String] the name of the service, used later to instantiate it when the mongoid configuration is fully loaded.
      attr_reader :name

      def initialize
        @location = false
        @service = false
        @name = false
      end

      # Determines if the application can be loaded (all the parameters have been correctly set)
      # @return [Boolean] TRUE if the application can be safely loaded, FALSE otherwise.
      def loadable?
        return !!(service && location)
      end

      # Getter for the path on which the service is mapped.
      # @return [String, Boolean] the absolute path in the URL on which the service is mapped upon, or FALSE if it's not set already.
      def path
        return service ? service.path : false
      end

      # Look for the service and sets it if it's found in the database, or set it to nil if not found.
      # @param [String] service_name - the name of the service to look for in the database.
      # @return [Arkaan::utils::MicroService] the instance of the micro-service to chain other calls.
      def register_as(service_name)
        @name = service_name
        return self
      end

      # Sets the location of the file calling the micro service and initializing it so that it's used as root.
      # @param filename [String] the full naame of the file with the extension.
      # @return [Arkaan::utils::MicroService] the instance of the micro-service to chain other calls.
      def from_location(filename)
        @location = File.dirname(filename)
        return self
      end

      # Loads the application in standard (production/development) mode, without the test files.
      # @return [Arkaan::utils::MicroService] the instance of the micro-service to chain other calls.
      def in_standard_mode
        return load_application(test_mode: false)
      end

      # Loads the application in test mode, by adding the needed files to run the test suite to the standard loading process.
      # @return [Arkaan::utils::MicroService] the instance of the micro-service to chain other calls.
      def in_test_mode
        @location = File.join(location, '..')
        return load_application(test_mode: true)
      end

      private

      def register_service(key)
        @service = Arkaan::Service.create(key: key, path: "/#{key}")
      end

      def register_instance
        instance = @service.instances.where(url: ENV['SERVICE_URL']).first
        if instance.nil?
          instance = Arkaan::Monitoring::Instance.create(service: @service, url: ENV['SERVICE_URL'])
        end
        return instance
      end

      def load_application(test_mode: false)
        load_mongoid_configuration
        if !!(name && location)
          @service = Arkaan::Monitoring::Service.where(key: service_name).first
          register_service if @service.nil?
          register_instance
          if service
            @location = File.join(location, '..') if test_mode
            load_standard_files
            load_test_files if test_mode
          end
        end
        return self
      end

      def load_mongoid_configuration
        Mongoid.load!(File.join(location, 'config', 'mongoid.yml'))
      end

      def load_standard_files
        require_folder('decorators')
        require_folder('controllers')
      end

      def load_test_files
        require_folder('spec', 'support')
        require_folder('spec', 'factories')
        require_folder('spec', 'shared')
      end

      def require_folder(*folders)
        Dir[File.join(location, folders)].each do |filename|
          require filename
        end
      end
    end
  end
end