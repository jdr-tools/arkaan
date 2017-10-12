module Arkaan
  module OAuth
    # A refresh token is used when an access token is expired, to get a new one. It is then recreated for the next expiration.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class RefreshToken
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] value
      #   @return [String] the value of the token, returned to the application when built.
      field :value, type: String, default: ->{ SecureRandom.hex }

      # @!attribute [rw] authorization
      #   @return [Arkaan::OAuth::Authorization] the authorization code that issued this token to the application for this user.
      belongs_to :authorization, class_name: 'Arkaan::OAuth::Authorization', inverse_of: :refresh_token
    end
  end
end