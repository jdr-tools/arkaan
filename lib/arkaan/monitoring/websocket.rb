module Arkaan
  module Monitoring
    # The websocket is a particular kind of service, just like the gateway. It always has the same signature.
    # A websocket document is a particular instance of websocket, located on a server and answering to a URL.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Websocket
      include Mongoid::Document
      include Mongoid::Timestamps
      include Arkaan::Concerns::Activable
      include Arkaan::Concerns::Diagnosticable

      # @!attribute [rw] url
      #   @return [String] the URL of the websocket to be contacted on.
      field :url, type: String

      # @!attribute [rw] creator
      #   @return [Arkaan::Account] the account that created this web socket instance in the database.
      belongs_to :creator, class_name: 'Arkaan::Account', inverse_of: :web_sockets, optional: true
      
      validates :url,
        presence: {message: 'required'},
        format: {with: /\A(https?:\/\/)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/, message: 'pattern', if: :url?}
    end
  end
end