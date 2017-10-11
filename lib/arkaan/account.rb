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
    # @!attribute [rw] lastname
    #   @return [String] the last name (family name) of the user.
    field :lastname, type: String, default: ''
    # @!attribute [rw] firstname
    #   @return [String] the first name of the user.
    field :firstname, type: String, default: ''
    # @!attribute [rw] birthdate
    #   @return [DateTime] the day of birth of the user, as an ISO-8601.
    field :birthdate, type: DateTime
    # @!attribute [rw] email
    #   @return [String] the email address of the user, useful to contact them.
    field :email, type: String

    validates :username, length: {minimum: 6}, uniqueness: true

    validates :email, presence: true, format: {with: /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}\z/}

    # @!attribute [rw] password
    #   @return [String] password, in clear, of the user ; do not attempt to get the value, just set it when changing the password.
    # @!attribute [rw] password_confirmation
    #   @return [String] the confirmation of the password, do not get, just set it ; it must be the same as the password.
    has_secure_password
  end
end