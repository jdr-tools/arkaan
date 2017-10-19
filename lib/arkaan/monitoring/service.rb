module Arkaan
  module Monitoring
    # A service is the representation of one of the applications composing the API.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Service
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] key
      #   @return [String] the name, or title of the service, optionally given to identify it more easily.
      field :key, type: String
      # @!attribute [rw] url
      #   @return [String] the URL of the service, where the requests will be issued.
      field :url, type: String

      # @!attribute [rw] creator
      #   @return [Arkaan::Account] the creator of this service.
      belongs_to :creator, class_name: 'Arkaan::Account', optional: true, inverse_of: :services

      validates :key, uniqueness: {message: 'service.key.uniq'}

      validates :url,
        presence: {message: 'service.url.blank'},
        format: {with: /\A(https?:\/\/)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/, message: 'service.url.format', if: :url?}
    end
  end
end