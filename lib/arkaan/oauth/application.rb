module Arkaan
  module OAuth
    # An application is what is referred to in the OAuth2.0 RFC as a client, wanting to access private informations about the user.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Application
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] name
      #   @return [String] the unique name of the application, mainly used to identify and display it.
      field :name, type: String
      # @!attribute [rw] key
      #   @return [String] the unique key for the application, identifying it when requesting a token for the API.
      field :key, type: String, default: ->{ SecureRandom.hex }

      # @!attribute [rw] creator
      #   @return [Arkaan::Account] the account that has created this application, considered its owner.
      belongs_to :creator, class_name: 'Arkaan::Account', inverse_of: :applications

      validates :name, presence: true, length: {minimum: 6}, uniqueness: true

      validates :key, presence: true, uniqueness: true
    end
  end
end