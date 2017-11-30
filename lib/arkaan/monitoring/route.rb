module Arkaan
  module Monitoring
    # A route is an endpoint accessible in a service. Each route has to have an associated endpoint in the deeeeployed instances.
    # @param Vincent Courtois <courtois.vincent@outlook.com>
    class Route
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Premiumable

      # @!attribute [rw] path
      #   @return [String] the path (URI) of the route in the service?
      field :path, type: String
      # @!attribute [rw] verb
      #   @return [String] the verb (HTTP method) of this route in the service.
      field :verb, type: String

      make_premiumable

      # @!attribute [rw] service
      #   @return [Arkaan::Monitoring::Service] the service in which this route is declared.
      embedded_in :service, class_name: 'Arkaan::Monitoring::Service', inverse_of: :routes
    end
  end
end