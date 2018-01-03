module Arkaan
  module Utils
    # The MicroService class is the loader for a micro service in general.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class MicroService

      # @!attribute [r] root
      #   @return [String] the root path of the application, from where each path is deduced.
      attr_reader :root
      # @!attribute [r] name
      #   @return [String] the name of the service, given when initializing it.
      attr_reader :name
      # @!attribute [r] test_mode
      #   @return [Boolean] TRUE if the micro service is initialized from a test suite, FALSE otherwise.
      attr_reader :test_mode
      # @!attribute [r] service
      #   @return [Arkaan::Monitoring::Service] the service stored in the database corresponding to this application.
      attr_reader :service

      # loads the application by requiring the files from the folders they're supposed to be in.
      # @param name [String] the snake-cased name of the application, for service registration purpose mainly.
      # @param root [String]
      def initialize(name:, root:, test_mode: false)
        @root = test_mode ? File.join(root, '..') : root
        @name = name
        @test_mode = test_mode
        @service = register_service
      end

      # Loads the necessary components for the application by requiring the needed files.
      # @param test_mode [Boolean] TRUE if the application i supposed to be launched from the spec_helper, FALSE otherwise.
      def load!
        self.require_mongoid_config(root)
        self.require_folder(root, 'decorators')
        self.require_folder(root, 'controllers')
        if test_mode
          self.require_folder(root, 'spec', 'support')
          self.require_folder(root, 'spec', 'shared')
        end
        return self
      end

      # Creates the service instance if necessary, and returns it.
      # @return [Arkaan::Monitoring::Service] the service in the registry corresponding to this micro-service.
      def register_service
        service = Arkaan::Monitoring::Service.where(key: @name).first
        if service.nil?
          service = Arkaan::Monitoring::Service.create!(key: @name, path: "/#{@name}", premium: true, active: true)
        end
        if service.instances.where(url: ENV['SERVICE_URL']).first.nil?
          Arkaan::Monitoring::Instance.create!(url: ENV['SERVICE_URL'], running: true, service: service, active: true)
        end
        return service
      end

      # Require all the files from a folder iteratively by assembling the parts given as parameters.
      # @param paths_elements [Array<String>] the elements to assemble to form the path of the folder.
      def require_folder(*paths_elements)
        Dir[File.join(paths_elements, '**', '*.rb')].each { |filename| require filename }
      end

      # Requires and loads the mongoid configuration from its default location.
      # @param root [String] the root folder of the application from where require the configuration path;
      def require_mongoid_config(root)
        Mongoid.load!(File.join(root, 'config', 'mongoid.yml'))
      end
    end
  end
end