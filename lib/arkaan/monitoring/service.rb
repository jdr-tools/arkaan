module Arkaan
  module Monitoring
    # A service is the representation of one of the applications composing the API.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Service
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Activable
      include Arkaan::Concerns::Diagnosticable
      include Arkaan::Concerns::Premiumable

      # @!attribute [rw] key
      #   @return [String] the name, or title of the service, optionally given to identify it more easily.
      field :key, type: String
      # @!attribute [rw] path
      #   @return [String] the path the service will be mapped on in the API.
      field :path, type: String, default: '/'
      # @!attribute [rw] test_mode
      #   @return [Boolean] TRUE if the service is currently in test mode and thus the gateway shall only qurty local instances.
      field :test_mode, type: Boolean, default: false

      # @!attribute [rw] creator
      #   @return [Arkaan::Account] the creator of this service.
      belongs_to :creator, class_name: 'Arkaan::Account', optional: true, inverse_of: :services
      # @!attribute [rw] instances
      #   @return [Array<Arkaan::Monitoring::Instance>] the instances of this service currently deployed.
      embeds_many :instances, class_name: 'Arkaan::Monitoring::Instance', inverse_of: :service
      # @!attribute [rw] routes
      #   @return [Array<Arkaan::Monitoring::Route>] the routes associated to this service, accessible from the gateway.
      has_many :routes, class_name: 'Arkaan::Monitoring::Route', inverse_of: :service

      validates :key, uniqueness: {message: 'uniq'}

      validates :path, format: {with: /\A(\/:?[a-z]+)+\z/, message: 'pattern'}
    end
  end
end