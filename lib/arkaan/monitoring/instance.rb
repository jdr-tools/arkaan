module Arkaan
  module Monitoring
    # An instance is one of the services, deployed on one server. A service may have many instances to balance the load between them all.
    # @param Vincent Courtois <courtois.vincent@outlook.com>
    class Instance
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Activable

      # @!attribute [rw] url
      #   @return [String] the URL of the instance, where the requests will be issued.
      field :url, type: String
      # @!attribute [rw] running
      #   @return [Boolean] the running status of the instance, indicating if it can be used or not.
      field :running, type: Boolean, default: false

      scope :running , ->{ where(running: true) }

      # @!attribute [r] service
      #   @return [Arkaan::Monitoring::Service] the service this instance is linked to.
      embedded_in :service, class_name: 'Arkaan::Monitoring::Service', inverse_of: :instances

      validates :url,
        presence: {message: 'instance.url.blank'},
        format: {with: /\A(https?:\/\/)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/, message: 'instance.url.format', if: :url?}
    end
  end
end