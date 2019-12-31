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
      # @!attirbute [rw] redirect_uris
      #   @return [Array<String>] the redirection URIs used for this application.
      field :redirect_uris, type: Array, default: []

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

      validate :redirect_uris_values

      # Checks the URIs to get sure they are correct, a URI is correct if :
      # - it is a string
      # - it has a correct URL format.
      def redirect_uris_values
        redirect_uris.each do |uri|
          if !uri.is_a? String
            errors.add(:redirect_uris, 'type')
            break
          elsif uri.match(/\A(https?:\/\/)((([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*)|(localhost:[0-9]{2,4})\/?)\z/).nil?
            errors.add(:redirect_uris, 'format')
            break
          end
        end
      end
    end
  end
end