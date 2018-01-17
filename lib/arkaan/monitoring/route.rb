module Arkaan
  module Monitoring
    # A route is an endpoint accessible in a service. Each route has to have an associated endpoint in the deployed instances.
    # @param Vincent Courtois <courtois.vincent@outlook.com>
    class Route
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Premiumable

      # @!attribute [rw] path
      #   @return [String] the path (URI) of the route in the service?
      field :path, type: String, default: '/'
      # @!attribute [rw] verb
      #   @return [String] the verb (HTTP method) of this route in the service.
      field :verb, type: String, default: 'get'

      make_premiumable

      # @!attribute [rw] service
      #   @return [Arkaan::Monitoring::Service] the service in which this route is declared.
      belongs_to :service, class_name: 'Arkaan::Monitoring::Service', inverse_of: :routes

      validates :path,
        format: {with: /\A(\/|((\/:?[a-zA-Z0-9]+)+))\z/, message: 'route.path.format', if: :path?}

      validates :verb,
        inclusion: {message: 'route.verb.unknown', in: ['get', 'post', 'put', 'delete', 'patch', 'option']}
    end
  end
end
