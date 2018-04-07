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
      # @!attribute [rw] premium
      #   @return [Boolean] a value indicating whether the application should automatically receive a token when an account is created, or not.
      field :premium, type: Boolean, default: false

      # @!attribute [rw] creator
      #   @return [Arkaan::Account] the account that has created this application, considered its owner.
      belongs_to :creator, class_name: 'Arkaan::Account', inverse_of: :applications
      # @!attribute [rw] authorizations
      #   @return [Array<Arkaan::OAuth::Authorization>] the authorizations linked to the accounts this application can get the data from.
      has_many :authorizations, class_name: 'Arkaan::OAuth::Authorization', inverse_of: :application

      validates :name,
        presence: {message: 'required'},
        length: {minimum: 6, message: 'minlength'},
        uniqueness: {message: 'uniq'}

      validates :key,
        presence: {message: 'required'},
        uniqueness: {message: 'uniq'}
    end
  end
end