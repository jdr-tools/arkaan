module Arkaan
  module Monitoring
    # A route is an endpoint accessible in a service. Each route has to have an associated endpoint in the deployed instances.
    # @param Vincent Courtois <courtois.vincent@outlook.com>
    class Route
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Premiumable
      include Arkaan::Concerns::Activable

      # @!attribute [rw] path
      #   @return [String] the path (URI) of the route in the service?
      field :path, type: String, default: '/'
      # @!attribute [rw] verb
      #   @return [String] the verb (HTTP method) of this route in the service.
      field :verb, type: String, default: 'get'
      # @!attribute [rw] authenticated
      #   @return [Boolean] if true, the session_id is needed for this route, if false it is not.
      field :authenticated, type: Boolean, default: true

      # @!attribute [rw] service
      #   @return [Arkaan::Monitoring::Service] the service in which this route is declared.
      belongs_to :service, class_name: 'Arkaan::Monitoring::Service', inverse_of: :routes

      # @!attribute [rw] groups
      #   @return [Array<Arkaan::Permissions::Group>] the groups having permission to access this route.
      has_and_belongs_to_many :groups, class_name: 'Arkaan::Permissions::Group', inverse_of: :groups

      validates :path,
        format: {with: /\A(\/|((\/:?[a-zA-Z0-9]+)+))\z/, message: 'route.path.format', if: :path?}

      validates :verb,
        inclusion: {message: 'route.verb.unknown', in: ['get', 'post', 'put', 'delete', 'patch', 'option']}
    end
  end
end
