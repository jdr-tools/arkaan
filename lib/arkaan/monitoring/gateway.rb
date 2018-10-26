module Arkaan
  module Monitoring
    # A gateway is a portal by which you access the different web services of the application suite.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Gateway
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Activable
      include Arkaan::Concerns::Diagnosticable
      include Arkaan::Concerns::Typable

      # @!attribute [rw] url
      #   @return [String] the URL of the gateway, where the requests will be issued.
      field :url, type: String
      # @!attribute [rw] running
      #   @return [Boolean] the running status of the gateway, indicating if it can be used or not.
      field :running, type: Boolean, default: false
      # @!attribute [rw] gateways
      #   @return [String] the uniq token for this gateway, identifying it in the micro services.
      field :token, type: String

      scope :running , ->{ where(running: true) }

      validates :url,
        presence: {message: 'required'},
        format: {with: /\A(https?:\/\/)((localhost:[0-9]+)|(([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*))\/?\z/, message: 'pattern', if: :url?}

      validates :token,
        presence: {message: 'required'},
        uniqueness: {message: 'uniq'}
    end
  end
end



