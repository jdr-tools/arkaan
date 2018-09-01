module Arkaan
  module Factories
    # This class provides methods to create decorated services.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Services

      # Searches for a service via its key and returns it decorated.
      # @param key [String] the key of the server you want to find.
      # @return [Arkaan::Decorators::Service, NilClass] nil if the service is not found, or the decorated service.
      def self.search(key)
        service = Arkaan::Monitoring::Service.where(key: key).first
        return nil if service.nil?
        return Arkaan::Decorators::Service.new(service)
      end
    end
  end
end