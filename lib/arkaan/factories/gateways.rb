module Arkaan
  module Factories
    # This class provides methods to create decorated services.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Gateways

      # Searches for a gateway via its key and returns it decorated.
      # @param key [String] the key of the server you want to find.
      # @return [Arkaan::Decorators::Gateway, NilClass] nil if the gateway is not found, or the decorated gateway.
      def self.random(action)
        gateway = Arkaan::Monitoring::Gateway.where(active: true, running: true).first
        if gateway.nil?
          raise Arkaan::Factories::Errors::GatewayNotFound.new(action: action)
        end
        return Arkaan::Decorators::Gateway.new(action, gateway)
      end
    end
  end
end