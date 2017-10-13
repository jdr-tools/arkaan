module Arkaan
  module OAuth
    # An access token is the value assigned to the application to access the private data of an account.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class AccessToken
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] value
      #   @return [String] the value of the token, returned to the application when built.
      field :value, type: String, default: ->{ SecureRandom.hex }
      # @!attribute [rw] expiration
      #   @return [Integer] the time, in seconds, after which the token is declared expired, and thus can't be used anymore.
      field :expiration, type: Integer, default: 86400

      # @!attribute [rw] authorization
      #   @return [Arkaan::OAuth::Authorization] the authorization code that issued this token to the application for this user.
      belongs_to :authorization, class_name: 'Arkaan::OAuth::Authorization', inverse_of: :access_token

      validates :value, presence: true, uniqueness: true
    end
  end
end