module Arkaan
  module Monitoring
    # An instance is one of the services, deployed on one server. A service may have many instances to balance the load between them all.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Instance
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Activable
      include Arkaan::Concerns::Typable

      # @!attribute [rw] url
      #   @return [String] the URL of the instance, where the requests will be issued.
      field :url, type: String
      # @!attribute [rw] running
      #   @return [Boolean] the running status of the instance, indicating if it can be used or not.
      field :running, type: Boolean, default: false
      # @!attribute [rw] data
      #   @return [Hash] the additional datas for this instance (for example for an Heroku instance it's all the data provided by the API)
      field :data, type: Hash, default: {}

      scope :running , ->{ where(running: true) }

      # @!attribute [r] service
      #   @return [Arkaan::Monitoring::Service] the service this instance is linked to.
      embedded_in :service, class_name: 'Arkaan::Monitoring::Service', inverse_of: :instances
      # @!attribute [rw] actions
      #   @return [Arkaan::Monitoring::Action] the actions that has been performed on the service.
      embeds_many :actions, class_name: 'Arkaan::Monitoring::Action', inverse_of: :instance

      validates :url,
        presence: {message: 'required'},
        format: {with: /\A(https?:\/\/)((([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*)|(localhost:[0-9]{2,4})\/?)\z/, message: 'pattern', if: :url?}
    end
  end
end

