module Arkaan
  module OAuth
    # An OAuth authorization is granted by a user to an application to access its personal data.
    # The application then transforms it into an access token to be able to send it with
    # further requests, so that we know the user has authorized the application to access its data.
    #
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Authorization
      include Mongoid::Document
      include Mongoid::Timestamps

      # @!attribute [rw] code
      #   @return [String] the value corresponding to the authentication code in the RFC of OAuth2.0, kep for historic purpose.
      field :code, type: String, default: ->{ SecureRandom.hex }

      # @!attribute [rw] account
      #   @return [Arkaaan::Account] the account granting the authorization to access its data to the application.
      belongs_to :account, class_name: 'Arkaan::Account', inverse_of: :authorizations
      # @!attribute [rw] application
      #   @return [Arkaan::OAuth::Application] the application asking to access account's data.
      belongs_to :application, class_name: 'Arkaan::OAuth::Application', inverse_of: :authorizations
      # @!attribute [rw] token
      #   @return [Arkaan::OAuth::AccessToken] the access token used further in the application process to access private data of the account.
      has_many :tokens, class_name: 'Arkaan::OAuth::AccessToken', inverse_of: :authorization

      validates :code,
        presence: {message: 'required'},
        uniqueness: {message: 'uniq'}
    end
  end
end