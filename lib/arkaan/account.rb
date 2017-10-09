module Arkaan
  # A user account with all related attributes. It holds credentials and informations about a designated user.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Account
    include Mongoid::Document
    include Mongoid::Timestamps
    include ActiveModel::SecurePassword

    # @!attribute [rw] username
    #   @return [String] the nickname the user chose at subscription, must be given, and 6 or more characters long.
    field :username, type: String
    # @!attribute [r] password_digest
    #   @return [String] the password of the user, encrypted with the Blowfish algorithm.
    field :password_digest, type: String

    validates :username, length: {minimum: 6}, uniqueness: true

    # @!attribute [rw] password
    #   @return [String] password, in clear, of the user ; do not attempt to get the value, just set it when changing the password.
    # @!attribute [rw] password_confirmation
    #   @return [String] the confirmation of the password, do not get, just set it ; it must be the same as the password.
    has_secure_password
  end
end